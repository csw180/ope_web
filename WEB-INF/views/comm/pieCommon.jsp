<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.net.*, com.shbank.orms.comm.util.*, java.util.Map.Entry" %>
<%@ page import="org.json.simple.*,java.net.*, org.apache.logging.log4j.Logger" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
%>	
{
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
		PlotBorderColor:"#A9AEB1",
        PlotBorderWidth:1,
		BackgroundColor:{
			LinearGradient : [0,0,100,500],
			Stops : [
				[0, "#D7E1F3"],
				[1, "#FFFFFF"]
			]
		},
		
		BorderColor : "#84888B",

		Type : "pie",

    },
    
    Title:{
			style:{
				Color:"#15498B",
				FontFamily:"Dotum",
				FontWeight:"bold",
				FontSize:"13px"
			},
			text:"파이,도넛  차트 유형"
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
	            			stops: [            [0, '#0072ff'],    [1, '#00c6ff']           ]	
						}
					
						,{	linearGradient: {x1: 0, x2: 0, y1: 1, y2: 0},
	            			stops: [            [0, '#f83600'],    [1, '#fe8c00']           ]	
						}	
						
						,{	linearGradient: {x1: 0, x2: 0, y1: 1, y2: 0},
							stops: [            [0, '#71B280'],    [1, '#E3F6CE']           ]	
						}	
						
						,{	linearGradient: {x1: 0, x2: 0, y1: 1, y2: 0},
							stops: [            [0, '#e9d362'],    [1, '#FFEAEE']           ]		
						}	
						
						,{ linearGradient: {x1: 0, x2: 0, y1: 1, y2: 0},
							stops: [            [0, '#6E48AA'],    [1, '#BD70DB']           ]	 
						}
	],
/*	
    Legend : {
		Enabled:true,
		align: 'right',
       verticalAlign: 'middle',
       layout: 'vertical'
		
    },
*/	
    Legend : {
		Enabled:false
    },

    YAxis : {
        LineColor : "#7F7F7F",
        TickInterval : 50,
		GridLineDashStyle : "solid",
        GridLineWidth : 1,
        GridLineColor : "#C4C9CD",
        LineWidth : 1,
        Title : {
            Text : ""
        }
    }
}