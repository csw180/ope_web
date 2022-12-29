document.write("<div id='men' style='display:none'></div>");
document.write("<div id='excel_div' style='display:none'></div>");

var EXCEL_MENU1="Save Excel(xls)";
var EXCEL_MENU2="Save Text(csv)";

var popup_width=160;
var popup_height=46;
var popup = null;

var G_CELL_TXT_FLG = true; 
/*
function popup_menu(){
	var popup_html = "";
	popup_html += "<html><link rel='STYLESHEET' type='text/css' href='/css/anzsoft.css'>";
	popup_html += "<body style='display:none;border-style:none;' scroll='no' >";
	popup_html += "<div style='background:#FFFA75; opacity:0;filter:alpha(opacity=0); list-style:none;width:"+popup_width+"px;border-left:1px solid #05499C;border-top:1px solid #05499C;border-bottom:1px solid #05499C;border-right:1px solid #05499C;'>";
	popup_html += "<div style='background:#FFFA75; opacity:0;filter:alpha(opacity=0); list-style:none;padding-left:5px;padding-top:5px;height:"+(popup_height/2-1)+"px;border-bottom:1px solid #05499C;' onmouseover='this.style.background=\"#0D004C\";this.style.color=\"white\";'  onmouseout='this.style.background=\"\";this.style.color=\"\";' onclick='parent.Excel_Save()'>" + EXCEL_MENU1;
	popup_html += "</div>";
	popup_html += "<div style='background:#FFFA75; opacity:0;filter:alpha(opacity=0); list-style:none;padding-left:5px;padding-top:5px;height:"+(popup_height/2-1)+"px;' onmouseover='this.style.background=\"#0D004C\";this.style.color=\"white\";'  onmouseout='this.style.background=\"\";this.style.color=\"\";' onclick='parent.Csv_Save()'>" + EXCEL_MENU2;
	popup_html += "</div></div>";
	popup_html += "</body></html>";
	return popup_html;
}
*/
function Excel_Save(){
	//popup.hide();
	grid2poi("bpaexcel","xls",poi_grid);
}

function Csv_Save(){
	//popup.hide();
	grid2poi("bpaexcel","csv",poi_grid);
}


var poi_grid = null;
var poi_contol = null;

$(function() {
	try{
	    $.contextMenu({
	        selector: '.aw-grid-control', 
	        callback: function(key, options) {
//	            var m = "clicked: " + key;
//	            window.console && console.log(m) || alert(m); 
	        	var src = options.$trigger[0];
	        	while(src.tagName!="BODY"){
	        		if($(src).hasClass("aw-grid-control")) {
	        		//if(src.aw=="control"){
	        			poi_contol = src;
	        		}
	        		src=src.parentElement;
	        	}

	        	poi_grid=AW.object(poi_contol.id);
	        	if(poi_grid==null) return;
	        	if(key=="excel"){
	        		Excel_Save();
	        	}else if(key=="csv"){
	        		Csv_Save();
	        		
	        	}
	        },
	        items: {
	            "excel": {name: EXCEL_MENU1, icon: "copy"},
	            "csv": {name: EXCEL_MENU2, icon: "paste"},
	            "sep1": "---------",
	            "quit": {name: "취소", icon: function(){
	                return 'context-menu-icon context-menu-icon-quit';
	            }}
	        }
	    });

	    $('.context-menu-one').on('click', function(e){
//	        console.log('clicked', this);
	    })    
		
	}catch(e){
		
	}
});



/*
function contextmenu(){
	var src = window.event.srcElement;
	while(src.tagName!="BODY"){
		if($(src).hasClass("aw-grid-control")) {
		//if(src.aw=="control"){
			poi_contol = src;
		}
		src=src.parentElement;
	}

	poi_grid=AW.object(poi_contol.id);
	if(poi_grid==null) return;
	
	
	var menx=event.screenX;
	var meny=event.screenY;
	var html=popup_menu();
	if(html=="") return false;
//	popup=window.createPopup();
	
	//popup.document.write(html);
	//popup.show(menx,meny,popup_width,popup_height);
	//popup.document.body.style.display="";

	$("#poi_popup").css("position","absolute");
	$("#poi_popup").css("left",""+menx+"px");
	$("#poi_popup").css("top",""+meny+"px");
	$("#poi_popup").css("width",""+popup_width+"px");
	$("#poi_popup").css("height",""+popup_height+"px");
	
	$("#poi_popup").html(html);
	$("#poi_popup").show();
}
*/
document.write("<form name='poiform' method='post' action='/excelWrite.do' target='_self'><input type='hidden' name='method' value='excelWrite'><input type='hidden' name='poixml' value=''><input type='hidden' name='poifilename' value=''></form>");

function grid2poi(file_name,type,arg0,arg1,arg2,arg3,arg4){
	var xmlDoc=new ActiveXObject("MSXML2.DOMDocument");
	xmlDoc.async = false;
	xmlDoc.loadXML("<poi></poi>");
	var root = xmlDoc.documentElement;

	for(var i=0;i<5;i++){
		if(eval("arg"+i)==null){
			break;
		}
		var obj = eval("arg"+i);
		var objid = poi_grid.getId();
		var newNode = xmlDoc.createNode(1, "sheets", "");
		var sheets = root.appendChild(newNode);
		newNode = xmlDoc.createNode(1, "columns", "");
		var columns = sheets.appendChild(newNode);
		newNode = xmlDoc.createNode(1, "lists", "");
		var lists = sheets.appendChild(newNode);
		for(var j=0;j<obj.getColumnCount();j++){
			newNode = xmlDoc.createNode(1, "column", "");
			var column = columns.appendChild(newNode);
			column.setAttribute("width", obj.getColumnWidth(j));
			var hidden = false;
			var ss=document.styleSheets[document.styleSheets.length-1];
			for(var ii=0;ii<ss.rules.length;ii++){
				var wk_label="#"+objid;
				var selectortext = grid2poi_trim(ss.rules[ii].selectorText);
				if(selectortext==".aw-column-"+j || selectortext==wk_label+".aw-column-"+j){
					if(ss.rules[ii].style.display=="none"){
						hidden = true;
					}
				}
			}
			column.setAttribute("hidden", ""+hidden);
			column.text=obj.getHeaderText(j);
		}
		for(var j=0;j<obj.getRowCount();j++){
			newNode = xmlDoc.createNode(1, "list", "");
			var list = lists.appendChild(newNode);

			for(var k=0;k<obj.getColumnCount();k++){
				newNode = xmlDoc.createNode(1, "cell", "");
				var cell = list.appendChild(newNode);
				try{
					if(G_CELL_TXT_FLG)
						cell.text=obj.getCellText(k,j);
					else 
						cell.text=obj.getCellValue(k,j);
				}catch(e){
					cell.text="";
				}
			}
		}
	}

	var f = document.poiform;
	f.poixml.value = xmlDoc.xml;
	if(file_name==null || file_name==""){
		f.poifilename.value = "excel_down";
	}else{
		f.poifilename.value = file_name;
	}
	if(type==null || type!="xls"){
		f.action="/csvWrite.do";
	}else{
		f.action="/excelWrite.do";
	}
	f.submit();
}

function grid2poi_trim(a){
	for(; a.indexOf(" ") != -1 ;){
		a = a.replace(" ","")
	}
	for(; a.indexOf("\t") != -1 ;){
		a = a.replace("\t","")
	}
	return a;
}

function grid2poi_XMLHttpRequest(){
	try{
		return new ActiveXObject("MSXML2.XMLHTTP");
	}catch(err){}
	try{
		return new ActiveXObject("Microsoft.XMLHTTP");
	}catch(err){}
	try{
		return new AZH_XMLHttpRequest();
	}catch(err){}
}