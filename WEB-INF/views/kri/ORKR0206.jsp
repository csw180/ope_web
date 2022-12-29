<%--
/*---------------------------------------------------------------------------
 Program ID   : ORKR0206.jsp
 Program name : KRI월별보고서(지주)
 Description  : 
 Programer    : 박승윤
 Date created : 2021.08.03
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script src="<%=System.getProperty("contextpath")%>/js/OrgInfP.js"></script>
	<script type="text/javascript" src="/ibchart/bin/ibchart.js"></script>
	<script type="text/javascript" src="/ibchart/bin/ibchartinfo.js"></script>
	<script src="<%=System.getProperty("contextpath")%>/js/jquery.fileDownload.js"></script>
	<script>
	
	var url = "<%=System.getProperty("contextpath")%>/comMain.do";
	
	$(document).ready(function(){
		// ibsheet 초기화
		initIBSheet1();
		initIBSheet2();
	});
	
	function search(){
		
		$("#info_bas_ym").text($("#bas_ym").val());
		mySheet1_doAction('search');
		mySheet2_doAction('search');
		
	} 
	
	function initIBSheet1() {
	
		mySheet1.Reset();
		
		var initData = {};
		
		initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; 
		initData.Cols = [
			{Header:"계열사별 KRI 허용한도 초과 현황(지표수준 : 전사)|그룹기관코드",Type:"Text",Width:100,Align:"Center",SaveName:"grp_org_c",MinWidth:60,Hidden:true},
			{Header:"계열사별 KRI 허용한도 초과 현황(지표수준 : 전사)|그룹기관명",Type:"Text",Width:100,Align:"Center",SaveName:"grp_orgnm",MinWidth:60},
			{Header:"계열사별 KRI 허용한도 초과 현황(지표수준 : 전사)|GREEN",Type:"Text",Width:100,Align:"Center",SaveName:"green_cnt",MinWidth:60},
			{Header:"계열사별 KRI 허용한도 초과 현황(지표수준 : 전사)|YELLOW",Type:"Text",Width:100,Align:"Center",SaveName:"yellow_cnt",MinWidth:60},
			{Header:"계열사별 KRI 허용한도 초과 현황(지표수준 : 전사)|RED",Type:"Text",Width:100,Align:"Center",SaveName:"red_cnt",MinWidth:60},
			{Header:"계열사별 KRI 허용한도 초과 현황(지표수준 : 전사)|GREEN 발생 비율",Type:"Text",Width:100,Align:"Center",SaveName:"green_ratio",MinWidth:60,Hidden:true},
			{Header:"계열사별 KRI 허용한도 초과 현황(지표수준 : 전사)|YELLOW 발생 비율",Type:"Text",Width:100,Align:"Center",SaveName:"yellow_ratio",MinWidth:60,Hidden:true},
			{Header:"계열사별 KRI 허용한도 초과 현황(지표수준 : 전사)|RED 발생 비율",Type:"Text",Width:100,Align:"Center",SaveName:"red_ratio",MinWidth:60},
			{Header:"계열사별 KRI 허용한도 초과 현황(지표수준 : 전사)|대응방안 입력 대상",Type:"Text",Width:100,Align:"Center",SaveName:"cft_plan_cnt",MinWidth:60}
	     ];
        
        IBS_InitSheet(mySheet1,initData);
        mySheet1.SetEditable(0);
   		mySheet1.SetSelectionMode(4);	
    }
		
		
	function initIBSheet2() {
		
		mySheet2.Reset();
		
		var initData = {};
		
		initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; 
		initData.Cols = [
			{Header:"공통 KRI 평가결과 현황|KRI속성|KRI속성코드",Type:"Text",Width:100,Align:"Center",SaveName:"idvdc_val",MinWidth:60,Hidden:true},
			{Header:"공통 KRI 평가결과 현황|KRI속성|KRI속성",Type:"Text",Width:100,Align:"Center",SaveName:"kri_attribute",MinWidth:60},
			{Header:"공통 KRI 평가결과 현황|GREEN|건수",Type:"Text",Width:100,Align:"Center",SaveName:"green_cnt",MinWidth:60},
			{Header:"공통 KRI 평가결과 현황|GREEN|비율",Type:"Text",Width:100,Align:"Center",SaveName:"green_ratio",MinWidth:60},
			{Header:"공통 KRI 평가결과 현황|YELLOW|건수",Type:"Text",Width:100,Align:"Center",SaveName:"yellow_cnt",MinWidth:60},
			{Header:"공통 KRI 평가결과 현황|YELLOW|비율",Type:"Text",Width:100,Align:"Center",SaveName:"yellow_ratio",MinWidth:60},
			{Header:"공통 KRI 평가결과 현황|RED|건수",Type:"Text",Width:100,Align:"Center",SaveName:"red_cnt",MinWidth:60},
			{Header:"공통 KRI 평가결과 현황|RED|비율",Type:"Text",Width:100,Align:"Center",SaveName:"red_ratio",MinWidth:60}
	     ];
        
        IBS_InitSheet(mySheet2,initData);
        mySheet2.SetEditable(0);
   		mySheet2.SetSelectionMode(4);	
    }
		
		
		
		
    
	var row = "";
	function mySheet1_doAction(str){
		switch(str){
			case 'search':
				var opt = {};
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("kri");
				$("form[name=ormsForm] [name=process_id]").val("ORKR020602");
				mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
				
			break;
		}

	}
    
    function mySheet1_OnSearchEnd(code,msg) {
    	if(code != 0) {
			alert("조회 중에 오류가 발생하였습니다..");
		}
    	/*%제거해서 pie차트에 그리게 하기위하여 */
		var pie_chart_green = mySheet1.GetCellValue(2,"green_ratio");
		var pie_chart_yellow = mySheet1.GetCellValue(2,"yellow_ratio");
		var pie_chart_red = mySheet1.GetCellValue(2,"red_ratio");
		$("#pie_chart_green").val(pie_chart_green.replace(/%/g,""));
		$("#pie_chart_yellow").val(pie_chart_yellow.replace(/%/g,""));
		$("#pie_chart_red").val(pie_chart_red.replace(/%/g,""));
		
		myChart1Draw();
		myChart2Draw();
    }
    
    function mySheet2_doAction(str){
		switch(str){
			case 'search':
				var opt = {};
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("kri");
				$("form[name=ormsForm] [name=process_id]").val("ORKR020603");
				mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
				
			break;
		}
		
	}
    
    function mySheet2_OnSearchEnd(code,msg) {
    	if(code != 0) {
			alert("조회 중에 오류가 발생하였습니다..");
		}
    	
    	myChart3Draw();
    }
	
	

	
	function myChart1Draw(){ //PIE
		//차트속성
		
		myChart1.RemoveAll();
		myChart1.SetOptions({

			Chart : {
				Animation : true,
				PlotBackgroundColor:{
					linearGradient: [250,0, 250, 500],
		            stops: [
		                [0, 'rgb(255, 255, 255)'],
		                [1, 'rgb(235, 235, 235)']
		            ]	
				},
				ZoomType:'xy',
				//PlotBorderColor:"#A9AEB1",
				PlotBorderColor:"#FFFFFF",
		        PlotBorderWidth:1,
				BackgroundColor:{
					LinearGradient : [0,0,100,500],
					Stops : [
						//[0, "#D7E1F3"],
						[0, "#FFFFFF"],
						[1, "#FFFFFF"]
					]
				},
				
				//BorderColor : "#84888B",
				BorderColor : "#FFFFFF",

				Type : "pie",

		    },
		   
		   Title:{
				style:{
					Color:"#15498B",
					FontFamily:"Dotum",
					FontWeight:"bold",
					FontSize:"13px"
				},
				text:"리스크등급별 분포"
	    	},
	    	
	    	plotOptions: {
	            pie: {
	                cursor: 'pointer',
	                depth: 35
	            }
	        },
	        Credits : {
				Enabled:false
			},
			Colors : [
						{	linearGradient: {x1: 0, x2: 0, y1: 1, y2: 0},
								stops: [[0, '#71B280'], [1, '#E3F6CE']]	
						 }	
						,{	linearGradient: {x1: 0, x2: 0, y1: 1, y2: 0},
								stops: [[0, '#E9D362'], [1, '#FFEAEE']]		
						 }	
						,{	linearGradient: {x1: 0, x2: 0, y1: 1, y2: 0},
					     		stops: [[0, '#F83600'], [1, '#FE8C00']]	
						 }	
			],
			
			Legend : {
				Enabled:false
		    }

		 });

		//차트 PlotOptions 속성

		myChart1.SetPlotOptions({
			Series:{
				DataLabels:{
					Enabled:true,
					Align:"center",
					Formatter:function(){
						return this.point.name + ': ' + this.y + '%' ;
					}
				}
			},
			Pie:{
				InnerSize:0,
				SlicedOffset:20,
				AllowPointSelect:true,
				showInLegend: true,
				 depth: 35
		    }

		},1);

		//차트 Series 설정
		var pie_cahrt_green = parseFloat($("#pie_chart_green").val());	
		var pie_cahrt_yellow = parseFloat($("#pie_chart_yellow").val());	
		var pie_cahrt_red = parseFloat($("#pie_chart_red").val());	
		
		myChart1.SetSeriesOptions([{

		    Type : "pie",
			
		    
		    Data : [

		      ["GREEN",pie_cahrt_green ],

		      ["YELLOW", pie_cahrt_yellow],

		      ["RED", pie_cahrt_red]

		    ]

		}], 1);

		myChart1.Draw();

	}

	function myChart2Draw()
	{
		myChart2.RemoveAll();

		//차트속성

		myChart2.SetOptions({

			Chart : {
				Animation : true,
				PlotBackgroundColor:{
					linearGradient: [250,0, 250, 500],
		            stops: [
		                [0, 'rgb(255, 255, 255)'],
		                [1, 'rgb(235, 235, 235)']
		            ]	
				},
				ZoomType:'xy',
				//PlotBorderColor:"#A9AEB1",
				PlotBorderColor:"#FFFFFF",
		        PlotBorderWidth:1,
				BackgroundColor:{
					LinearGradient : [0,0,100,500],
					Stops : [
						//[0, "#D7E1F3"],
						[0, "#FFFFFF"],
						[1, "#FFFFFF"]
					]
				},
				
				//BorderColor : "#84888B",
				BorderColor : "#FFFFFF",

				Type : "column",

		    },
		   Title:{
				style:{
					Color:"#15498B",
					FontFamily:"Dotum",
					FontWeight:"bold",
					FontSize:"13px"
				},
				text:"계열사 별 RED등급 발생 비율"
	    	},
	    	plotOptions: {
	            pie: {
	                cursor: 'pointer',
	                depth: 35
	            }
	        },
	        Credits : {
				Enabled:false
			},
	    	Colors : [
	    	            {	linearGradient: {x1: 0, x2: 0, y1: 1, y2: 0},
					     		stops: [[0, '#F83600'], [1, '#FE8C00']]	
						 }	
			]

      });
		
		var axisXdata = [];
		for(var i=0;i<13;i++){
			axisXdata[i] = mySheet1.GetCellValue(i,"grp_orgnm") ;
		}
		var axisYdata = [];
		for(var i=0;i<13;i++){
			axisYdata[i] = parseFloat((mySheet1.GetCellValue(i,"red_ratio").replace(/%/g,"")));
		}

       myChart2.SetXAxisOptions({

        Title:{

             Text:"계열사"   // 타이틀 설정

             },

       Offset:7,
       LineWidth:0,

       labels:{
          
             Enabled:true,
          
             Align:"center",
          	

             	
             Rotation:-12,   
          
             Style:{
          
          
               FontWeight:'bold',
          
               FontSize:'10px'
          
             }
          
            },

     

       	 Categories : [ axisXdata[3],
            	        axisXdata[4],
            	        axisXdata[5],
            	        axisXdata[6],
            	        axisXdata[7],
            	        axisXdata[8],
            	        axisXdata[9],
            	        axisXdata[10],
            	        axisXdata[11],
            	        axisXdata[12]
            	           ],  //X축 레이블 설정 
            	           

            	   }, 1);
        
		myChart2.SetYAxisOptions({

			Title:{

			     Text:"비율(%)"  //타이틀 설정

			    },
			    


			    GridLineWidth : 2,  //라인 넓이설정

			    TickInterval : 10  // Tick 간격을 10으로 설정

			}, 1);


		//차트 PlotOptions 속성
		
		myChart2.SetPlotOptions({

		           Column:{                     //컬럼 차트 속성

		                     DashStyle:"Dot",   //선스타일 Dot

		                PointPadding:0

		           },
	                Series:{
	                	DataLabels:{
	                		Enabled:true,
	                		Align:"center",
	                		Formatter:function(){
	                			return this.y + '%' ;
	                		}
	                	}
	                }

		});
		
		
		myChart2.SetSeriesOptions([{
					
					Name : "RED 등급 발생 비율",

		            Data : [
							 
		                      {Y:axisYdata[2]},
		                      {Y:axisYdata[3]},
		                      {Y:axisYdata[4]},
		                      {Y:axisYdata[5]},
		                      {Y:axisYdata[6]},
		                      {Y:axisYdata[7]},
		                      {Y:axisYdata[8]},
		                      {Y:axisYdata[9]},
		                      {Y:axisYdata[10]},
		                      {Y:axisYdata[11]}
		                      

		            ],
		            DataLabels:{

                        Enabled:true,

                        Color:"black"

                     }



		 }], 1);
		
		myChart2.Draw();
	}
	
	function myChart3Draw()
	{
		myChart3.RemoveAll();

		//차트속성

		myChart3.SetOptions({

			Chart : {
				Animation : true,
				PlotBackgroundColor:{
					linearGradient: [250,0, 250, 500],
		            stops: [
		                [0, 'rgb(255, 255, 255)'],
		                [1, 'rgb(235, 235, 235)']
		            ]	
				},
				ZoomType:'xy',
				//PlotBorderColor:"#A9AEB1",
				PlotBorderColor:"#FFFFFF",
		        PlotBorderWidth:1,
				BackgroundColor:{
					LinearGradient : [0,0,100,500],
					Stops : [
						//[0, "#D7E1F3"],
						[0, "#FFFFFF"],
						[1, "#FFFFFF"]
					]
				},
				
				//BorderColor : "#84888B",
				BorderColor : "#FFFFFF",

				Type : "column",

		    },
		   Title:{
				style:{
					Color:"#15498B",
					FontFamily:"Dotum",
					FontWeight:"bold",
					FontSize:"13px"
				},
				text:"공통 KRI 평가결과 현황"
	    	},
	    	plotOptions: {
	            pie: {
	                cursor: 'pointer',
	                depth: 35
	            }
	        },
	        Credits : {
				Enabled:false
			},
			Colors : [
						{	linearGradient: {x1: 0, x2: 0, y1: 1, y2: 0},
								stops: [[0, '#71B280'], [1, '#E3F6CE']]	
						 }	
						,{	linearGradient: {x1: 0, x2: 0, y1: 1, y2: 0},
								stops: [[0, '#E9D362'], [1, '#FFEAEE']]		
						 }	
						,{	linearGradient: {x1: 0, x2: 0, y1: 1, y2: 0},
					     		stops: [[0, '#F83600'], [1, '#FE8C00']]	
						 }	
			]

      });
		
		var axisXdata = [];
		for(var i=0;i<8;i++){
			axisXdata[i] = mySheet2.GetCellValue(i,"kri_attribute") ;
		}
		var axisYdata_green = [];
		for(var i=0;i<8;i++){
			axisYdata_green[i] = parseFloat((mySheet2.GetCellValue(i,"green_ratio").replace(/%/g,"")));
		}
		var axisYdata_yellow = [];
		for(var i=0;i<8;i++){
			axisYdata_yellow[i] = parseFloat((mySheet2.GetCellValue(i,"yellow_ratio").replace(/%/g,"")));
		}
		var axisYdata_red = [];
		for(var i=0;i<8;i++){
			axisYdata_red[i] = parseFloat((mySheet2.GetCellValue(i,"red_ratio").replace(/%/g,"")));
		}
		
	   	
       myChart3.SetXAxisOptions({

        Title:{

             Text:"KRI속성"   // 타이틀 설정

             },

       Offset:7,
       LineWidth:0,

       labels:{
          
             Enabled:true,
          
             Align:"center",
          	

             	
             Rotation:-12,   
          
             Style:{
          
          
               FontWeight:'bold',
          
               FontSize:'10px'
          
             }
          
            },

     

       	 Categories : [ axisXdata[3],
            	        axisXdata[4],
            	        axisXdata[5],
            	        axisXdata[6],
            	        axisXdata[7]
            	       ],  //X축 레이블 설정 
            	           

            	   }, 1);
        
		myChart3.SetYAxisOptions({

			Title:{

			     Text:"비율(%)"  //타이틀 설정

			    },
			    


			    GridLineWidth : 2,  //라인 넓이설정

			    TickInterval : 10  // Tick 간격을 10으로 설정

			}, 1);


		//차트 PlotOptions 속성
		
		myChart3.SetPlotOptions({

		           Column:{                     //컬럼 차트 속성

		                     DashStyle:"Dot",   //선스타일 Dot
		                     Stacking : "normal",
		                	 PointPadding:0

		           },
	                Series:{
	                	DataLabels:{
	                		Enabled:true,
	                		Align:"center",
	                		Formatter:function(){
	                			return this.y + '%' ;
	                		}
	                	}
	                }

		});
		
		
		myChart3.SetSeriesOptions([
		    {
			   Type:"column", Name : "GREEN",   Data : [axisYdata_green[3],
			                                            axisYdata_green[4],
			                                            axisYdata_green[5],
			                                            axisYdata_green[6],
			                                            axisYdata_green[7]]

			},{

			   Type:"column", Name : "YELLOW",  Data : [axisYdata_yellow[3],
			                                            axisYdata_yellow[4],
			                                            axisYdata_yellow[5],
			                                            axisYdata_yellow[6],
			                                            axisYdata_yellow[7]]

			},{

			   Type:"column", Name : "RED",   Data :   [axisYdata_red[3],
			                                            axisYdata_red[4],
			                                            axisYdata_red[5],
			                                            axisYdata_red[6],
			                                            axisYdata_red[7]]}
			], 1);

		
		myChart3.Draw();
	}
	


	
	function down2Excel(){
		var f = document.ormsForm;
		
		$("#svg1").val(replaceAll(replaceAll($("#myChart1").find("svg").parent().html(),"&quot;","'"),"1e-005","1"));
		$("#svg2").val(replaceAll(replaceAll($("#myChart2").find("svg").parent().html(),"&quot;","'"),"1e-005","1"));
		$("#svg3").val(replaceAll(replaceAll($("#myChart3").find("svg").parent().html(),"&quot;","'"),"1e-005","1"));
		
		showLoadingWs(); // 프로그래스바 활성화
		$.fileDownload("<%=System.getProperty("contextpath")%>/fgOrmKriReportExcel.do", {
			httpMethod : "POST",
			data : $("#ormsForm").serialize(),
			successCallback : function(){
				  removeLoadingWs();
				
			},
			failCallback : function(msg){
				  removeLoadingWs();
				  alert(msg);
				
			}
		});
		
	}


	</script>
</head>
<body>
	<div class="container">
		<!-- Content Header (Page header) -->
		<%@ include file="../comm/header.jsp" %>

		<div class="content">
			<form id="ormsForm" name="ormsForm" method="post">
				<input type="hidden" id="path" name="path" />
				<input type="hidden" id="process_id" name="process_id" />
				<input type="hidden" id="commkind" name="commkind" />
				<input type="hidden" id="method" name="method" />
				<input type="hidden" id="pie_chart_green" name="pie_chart_green" value="" />
				<input type="hidden" id="pie_chart_yellow" name="pie_chart_yellow" value="" />
				<input type="hidden" id="pie_chart_red" name="pie_chart_red" value="" />
				<input type="hidden" id="svg1" name="svg1" value="" />
				<input type="hidden" id="svg2" name="svg2" value="" />
				<input type="hidden" id="svg3" name="svg3" value="" />
				
				<div id="del_area"></div>
				<!-- 조회 -->
				<!-- .search-area 검색영역 -->
				<div class="box box-search">
					<div class="box-body">
						<div class="wrap-search">
							<table>  
								<tbody>
									<tr> 
										<th>평가년월</th>
										<td class="form-inline">
											<span class="select">
												<select class="form-control" id="bas_ym" name="bas_ym" >
<%
	if (vLst != null)
		for(int i=0;i<vLst.size();i++){
			HashMap hMap = (HashMap)vLst.get(i);
%>
													<option value="<%=(String)hMap.get("bas_ym")%>"><%=(String)hMap.get("bas_ym")%></option>
<%
		}
%>
												</select>
											</span>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div><!-- .box-body //-->
					<div class="box-footer">
						<button type="button" class="btn btn-primary search" onClick="javascript:search();">조회</button>
					</div>
				</div><!-- .search-area //-->
			</form>
			<!-- Main content -->
				<div class="box box-grid">
					<div class="box-header">
						<h2 class="box-title">0. 평가정보</h2>
						<div class="area-tool">
							<button type="button" class="btn btn-xs btn-default" onclick="javascript:down2Excel();"><i class="ico xls"></i>엑셀 다운로드</button>
						</div> 
					</div>
					<div class="box-body">
						<div class="wrap-table">
							<table class="w500">
								<colgroup>
									<col style="width: 150px;">
									<col>
								</colgroup>
								<tbody class="center">
									<tr>
										<th>평가년월</th>
										<th>평가조직</th>
									</tr>
									<tr>
										<td id="info_bas_ym" style="text-align:center;">&nbsp;</td>
										<td id="info_brnm" style="text-align:center;">지주</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			
				<div class="box box-grid">
					<div class="box-header">
						<h2 class="box-title">1. 계열사 별 KRI 허용한도초과 현황(지표수준 : 전사)</h2>
					</div>
					<div class="box-body">
						<div class="wrap-grid h450">
							<script> createIBSheet("mySheet1", "100%", "100%"); </script>
						</div>
					</div>
				</div>
				<div class="row mt30">
						<div class="col w400">
							<div class="wrap-grid h350">
								<script> createIBChart("myChart1","100%","100%"); </script>
							</div>
						</div>
						<div class="col">
							<div class="wrap-grid h350">
								<script> createIBChart("myChart2","100%","100%"); </script>
							</div>
						</div>
				</div>
				<div class="box box-grid">
					<div class="box-header">
						<h2 class="box-title">2. 공통 KRI 등급 현황(지표수준 : 전사)</h2>
					</div>
					<div class="box-body">
						<div class="wrap-grid h300">
							<script> createIBSheet("mySheet2", "100%", "100%"); </script>
						</div>
					</div>
				</div>
				<div class="row mt30">
					<div class="col">
						<div class="wrap-grid h350">
							<script> createIBChart("myChart3","100%","100%"); </script>
						</div>
					</div>
				</div>
		</div><!-- .container //-->
	</div>

</body>
</html>
