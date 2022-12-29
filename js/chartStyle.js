// Chart
var gridColor = {
	"primary" : "#0068b7",
	"primary_bg" : "#f0f8fd",
	"red" : "#db1313",
	"red_bg" : "#fff6f6",
	"yellow" : "#e99200",
	"yellow_bg" : "#fff9ee",
	"green" : "#349b48",
	"green_bg" : "#ecfbef",
	"blue" : "#618cc7",
	"blue_bg" : "#d8ebf7",
	"blue_dark" : "#37629c",
	"gray" : "#888",
	"gray_bg" : "#ddd",
	"etc" : "#5793c2",
	"white" : "#fff",
	"th_bg"	: "#FAFEFF"
};

var initChartType = {
	Chart:{
		BackgroundColor: "#FFFFFF",
		PlotBackgroundColor:"#FFFFFF",
		BorderWidth: 0,
		BorderColor: "#E0E0E0",
		Margin: [10, 10, 70, 50]
	},

	Colors: [
		gridColor.blue, gridColor.red, gridColor.green, gridColor.yellow, gridColor.gray
	],

	plotOptions: {
		Series: {
			Shadow: false,
			Animation: false,
			DataLabels: {
				Align: "center"
			}
		},
		Column: {
			//PointWidth: 22,
		},
		Line: {
			DataLabels :{
				Enabled: false,
				Format: "{point.y}"
			}
		},
		Pie: {
			ShowInLegend: true,
			Size: 180,
			DataLabels :{
				Enabled: true,
				Distance: -30,
				Style: {
					Color: "#fff",
					FontSize: "13px",
					TextShadow : "1px 1px 2px rgba(0,0,0,0.8)"
				},
				Format: "{point.name}"
			}
		}
		
	},

	Legend: {
		Layout : "horizontal",
		Align : "center",
		VerticalAlign : "bottom",
		Y : 5,
		Floating: false,
		BorderWidth : 0,
		BackgroundColor: "#fff",
		BorderColor: "#e0e0e0",
		BorderWidth: 1,
		ItemStyle: {
			Color : "#555",
			FontFamily : "'Malgun-gothic', sans-serif",
		}
	},

	XAxis: {
		GridLineWidth: 0,
		LineWidth: 1,
		LineColor : "#e0e0e0",
		TickWidth: 0,
		Labels:{
			Enabled: true,
			Align: "center",
			Style:{
				Color : "#555",
				FontWeight:'bold',
				FontFamily : "'Malgun-gothic', sans-serif",
				FontSize: '12px',
			},
			Y : 20
		},

	},

	YAxis: [
		{
			GridLineColor: "#e0e0e0",
			GridLineWidth: 1,
			LineColor : "#e0e0e0",
			Min : 0,
			Title : {
				Text: "",
				Margin : 5,
				FontFamily : "'Malgun-gothic', sans-serif",
				FontSize: '12px',
			}
		},{
			Opposite:true,
			LineColor : "#e0e0e0",
			Min : 0,
			Title : {
				Text : "",
				Margin : 5,
				FontFamily : "'Malgun-gothic', sans-serif",
				FontSize: '12px',
			}
		}
	],

	ToolTip: {
		Enabled : true,
		HeaderFormat : "<div class='chart-tooltip-header'>{point.key}</div>",
		PointFormat : "<p class='chart-tooltip'>{series.name} : <strong>{point.y}</strong></p>",
		Style : {
			BackgroundColor: gridColor.white,
		},
		useHTML : true
	}
}



// Color - 등급
var chartColorGrade = [
	gridColor.green, 	// Green
	gridColor.yellow, 	// Yellow
	gridColor.red 	// Red
];
var chartColorGradeR = [
	gridColor.red, 	// Red
	gridColor.yellow, 	// Yellow
	gridColor.green, 	// Green
	gridColor.etc	// Etc(Blue)
];

// Color - grayscale
var chartColorGray = [
	"#666",
	"#777",
	"#888",
	"#999",
	"#aaa",
	"#bbb",
	"#ccc",
	"#ddd",
	"#eee",
];



// 오른쪽 Y축
var chartSecY = {
	Chart:{
		Margin: [10, 50, 70, 50]
	},
}



/*** 대시보드 ***/
// 대시보드 - 누적 손실 금액 - 원형차트
var dasLosChart = {
	Chart: {
		BackgroundColor: "transparent",
		PlotBackgroundColor:"transparent",
		Type : "pie",
		Margin : [10, 10, 10, 10]
	},
	Colors: chartColorGray,
	plotOptions : {
		Pie : {
			Size : 220,
			InnerSize : 160,
			DataLabels : false,
		}
	},
	Legend : {
		Enabled : false,
		Layout : "vertical",
	},
	ToolTip : {
		Style : {
			LineHeight : "20px",
			ZIndex : 10,
		},
		valueSuffix : " 원",
		PointFormat : "<p class='chart-tooltip'><strong>{point.y}</strong></p><p class='chart-tooltip'>비중 : <strong>{point.percentage:.0f} %</strong></p>",
		BorderColor : gridColor.primary
	}

}


// 대시보드 - 규제 자본 산출 결과
var dasRepcapChart = {
	Chart: {
		Type: "column",
		Margin: [10, 1, 30, 50]
	},
	plotOptions: {
		column: {
			PointWidth: 30,
			ColorByPoint: true,
			DataLabels : {
				Align: "Center",
				VerticalAlign: "bottom", 
				Color: gridColor.blue,
				Style: {
					FontSize: 15,
					FontWeight: 700,
				}
			},
		}
	},
	Colors : [gridColor.gray, gridColor.gray, gridColor.gray, gridColor.blue],
	Legend: {
		Enabled: false
	},
	ToolTip : {
		valueSuffix : " 억 원",
		PointFormat : "<p class='chart-tooltip'><strong>{point.y}</strong></p>",
	},
}


// 대시보드 - 내부 자본 산출 결과
var dasIntcapChart = {
	Chart: {
		Type: "bar",
		Margin: [1, 1, 65, 1]
	},
	plotOptions: {
		bar: {
			PointWidth: 24,
			PointPadding: 0,
			DataLabels : {
				Color: "#fff",
		//		BackgroundColor: "rgba(136, 136, 136, 0.5)",
				BorderRadius: 3,
				BorderWidth: 0,
				style: {
					TextShadow : "1px 0 2px #888, 0 1px 2px #888, -1px 0 2px #888, 0 -1px 2px #888"
				}
			},
		}
	},
	Colors : [gridColor.gray, gridColor.blue_dark, gridColor.blue],
	Legend: {
		Layout : "horizontal",
		Align : "center",
		VerticalAlign : "bottom",
		Y : 13,
		Reversed : true
	},
	XAxis: {
		Labels :{
			Enabled: false
		}
	},
	YAxis: {
	//	Max : 100
	},
	ToolTip : {
		valueSuffix : " %",
		PointFormat : "<p class='chart-tooltip'><strong>{point.y}</strong></p>",
	},
}



// 대시보드 - KRI 조회 - 라인차트
var dasKriLine = {
	Chart: {
		Type: "line",
	},
	ToolTip : {
		valueSuffix : " 건",
	}
}


//대시보드 - KRI 조회 - 원형차트
var dasKriPie = {
	Chart: {
		Type : "pie",
		Margin : [10, 10, 10, 10]
	},
	Colors: chartColorGray,
	plotOptions : {
		Pie : {
			Size : 220,
			DataLabels : false,
		}
	},
	Legend : {
		Enabled : false,
	},
	ToolTip : {
		Style : {
			LineHeight : "20px",
			ZIndex : 10,
		},
		valueSuffix : " 건",
		PointFormat : "<p class='chart-tooltip'><strong>{point.y}</strong></p>",
		BorderColor : gridColor.red
	}

}

//대시보드 - KRI 조회 - 전월
var dasKriPie_before = {
	Chart: {
		BackgroundColor: "transparent",
		PlotBackgroundColor:"transparent",
		Margin : [30, 10, 10, 10]
	},
	plotOptions : {
		Pie : {
			Size : 160,
			InnerSize : 80,
		}
	},
}

//대시보드 - KRI 조회 - 당월
var dasKriPie_current = {
	Chart: {
		BackgroundColor: "transparent",
		PlotBackgroundColor:"transparent",
		Margin : [30, 10, 10, 10]
	},
	plotOptions : {
		Pie : {
			Size : 200,
			InnerSize : 80,
		}
	},
}



/*** 측정 ***/

// 측정 - 자본량 산출 내역 조회 및 모니터링
var msrMonitor_1 = {
	Chart: {
		Type : "column",
		//Margin: [10, 50, 70, 50]
	},
	Colors: chartColorGray,
	ToolTip : {
		valueSuffix : " 원",
		PointFormat : "<p class='chart-tooltip' style='width: 150px'>BIC : <strong id='tooltip-BIC'></strong></p><p class='chart-tooltip'>LC : <strong id='tooltip-LC'>{chart1_data_BIC[}{point.x}{]}</strong></p><p class='chart-tooltip'>{series.name} : <strong>{point.y}</strong></p>",
	}
		
}

var msrMonitor_2 = {
	Colors: [ gridColor.blue, gridColor.yellow, gridColor.green ],
	ToolTip : {
		HeaderFormat : "<div class='chart-tooltip-header'>{point.key}</div><p class='chart-tooltip-header'>{series.name}</p>",
		PointFormat : "<p class='chart-tooltip' style='width: 180px'>BIC : <strong id='tooltip-BIC'></strong></p><p class='chart-tooltip'>LC : <strong id='tooltip-LC'>{chart1_data_BIC[}{point.x}{]}</strong></p><p class='chart-tooltip'>{series.name} : <strong>{point.y}</strong></p>",
	}
		
}

var msrMonitor_3 = {
	Chart: {
		Type : "column",
		//Margin: [10, 50, 70, 50]
	},
	Colors: [ gridColor.primary, gridColor.blue ],
	ToolTip : {
		valueSuffix : " %",
	},
	YAxis: {
		PlotLines : [
			{
				Value: 85,
				Color: gridColor.yellow,
				DashStyle: "Dash",
				Width: 2,
				ZIndex : 5
			},
			{
				Value: 90,
				Color: gridColor.red,
				DashStyle: "Dash",
				Width: 2,
				ZIndex : 5
			}
		]
	},
}

