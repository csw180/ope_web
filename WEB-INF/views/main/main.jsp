<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.*, com.shbank.orms.comm.util.*"%>
<%@ include file="../comm/contextpath.jsp" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setDateHeader("Expires", 0);
	response.setHeader("Cache-Control", "no-cache");

	DynaForm form = (DynaForm)request.getAttribute("form");
	String menu_id = "";
	if(form!=null) menu_id = (String)form.get("menu_id");
	if(menu_id==null) menu_id = "";

	HashMap hMap = (HashMap)request.getSession(true).getAttribute("infoH");
	String userid = (String)hMap.get("userid");
	String grp_org_c =  (String)hMap.get("grp_org_c");
	String grp_orgnm = (String)hMap.get("grp_orgnm");

	String brnm = (String)hMap.get("brnm");
	//String ebr_nm = (String)hMap.get("ebr_nm");
	String empnm = (String)hMap.get("chrg_empnm");
	String pzcnm = (String)hMap.get("pzcnm");
	String brc = (String)hMap.get("brc");
	String dept_dsc = (String)hMap.get("dept_dsc");
	String hofc_bizo_dsc = (String)hMap.get("hofc_bizo_dsc");
	String orgz_cfc = (String)hMap.get("orgz_cfc");
	String adm_yn = (String)hMap.get("adm_yn");
	String puser = (String)request.getSession(true).getAttribute("puser");
	ArrayList auth_ids = (ArrayList)hMap.get("auth_ids");
	if(auth_ids==null) auth_ids = new ArrayList();
	boolean isFGOrm = false; //지주ORM
	for(int i=0;i<auth_ids.size();i++){
		String auth_id = (String)auth_ids.get(i);
		if(auth_id.equals("011")){
			isFGOrm = true;
		}
	}
	
	if(puser==null) puser = "";
	
	if(menu_id == ""){
		//지주사이면서 
		
		if(hofc_bizo_dsc.equals("02")){ //본부부서 : 0001301
			menu_id = "0001301";
		}else if(hofc_bizo_dsc.equals("03") && orgz_cfc.equals("07")){ //영업본부 : 0001401
			menu_id = "0001401";
		}else if(hofc_bizo_dsc.equals("03") && !orgz_cfc.equals("07")){ //영업점 : 0001301
			menu_id = "0001301";
//		}else if(hofc_bizo_dsc.equals("04")){ //해외 : 0000240
//			menu_id = "0000240";
		}else if(hofc_bizo_dsc.equals("01")){ //전사 : 0001101, ORM : 0001201
			if(isFGOrm){  //지주ORM
				menu_id = "0001101";
			}else{
				menu_id = "0001201";
			}
		}else{
			
		}
	}
	
	//HashMap hMap_schdule = (HashMap)request.getAttribute( "hMap_schdule" );
	//if(hMap_schdule==null) hMap_schdule = new HashMap();

	Vector vSystemBrList = (Vector)request.getSession(true).getAttribute("vSystemBrList");

	Vector vBrList = (Vector)request.getSession(true).getAttribute( "vBrList");
	
	int org_count =0;
	if(vBrList ==null){
		vBrList = new Vector();
	}
	org_count = vBrList.size();

	//System.out.println("vList:"+vBrList);
	//System.out.println("org_count:"+org_count);
	Vector vMnuList = (Vector)request.getAttribute( "vMnuList");
	System.out.println("vMnuList:"+vMnuList);
	if(vMnuList ==null){
		vMnuList = new Vector();
	}
	

	String SYSDATE = (String)request.getAttribute("sysdate");
	
	String SCHEDULE_FIELD = "";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<!-- <meta http-equiv="Content-Security-Policy" content="default-src 'self'; style-src 'self'; img-src https://*; chaild-src 'none'; " /> -->
<meta name="referrer" content="strict-origin-when-cross-origin" />
<meta name="copyright" content="Copyright DGB Financial Group" />
<title><%=grp_orgnm %> 운영리스크 관리시스템</title>
<link rel="shortcut icon" href="<%=System.getProperty("contextpath")%>/imgs/favicon.ico" type="image/x-icon">

<%--  NaN Orms start --%>
<%-- Bootstrap 3.3.7 --%>
<link rel="stylesheet" href="<%=System.getProperty("contextpath")%>/styles/bootstrap.min.css">
<%-- <link rel="stylesheet" href="/css/non-responsive.css"> --%>
<%-- Font Awesome --%>
<link rel="stylesheet" href="<%=System.getProperty("contextpath")%>/styles/font-awesome.min.css">
<%-- Theme style --%>
<link rel="stylesheet" href="<%=System.getProperty("contextpath")%>/styles/style.css">

<%--[if lt IE 9]>
	<script src="<%=System.getProperty("contextpath")%>/js/html5shiv.min.js"></script>
	<script src="<%=System.getProperty("contextpath")%>/js/respond.min.js"></script>
	<![endif]--%>

<%--  NaN Orms end --%>

<script type="text/javascript" src="<%=System.getProperty("contextpath")%>/js/jquery/jquery-3.1.1.min.js"></script>
<script type="text/javascript" src="<%=System.getProperty("contextpath")%>/js/wp.js"></script>
<script type="text/javascript" src="<%=System.getProperty("contextpath")%>/js/common.js"></script>
<script type="text/javascript" src="<%=System.getProperty("contextpath")%>/ibsheet/bin/ibsheetinfo.js"></script>
<script type="text/javascript" src="<%=System.getProperty("contextpath")%>/ibsheet/bin/ibsheet.js"></script>
<script type="text/javascript" src="<%=System.getProperty("contextpath")%>/ibsheet/bin/ibleaders_<%=System.getProperty("svrflag")%>.js"></script>

<script type="text/javascript">
	var APP_VERSION=0;
	var isIE=false;

	if(navigator.appName!="") browser="No browser,";
	else browser=navigator.appName;

	APP_VERSION = parseFloat(navigator.appVersion);
	if((Math.round(parseFloat(navigator.appVersion)*100)) - (parseInt(navigator.appVersion) * 100) == 0) APP_VERSION = APP_VERSION + ".0";

	if(navigator.appName.substring(0,9) == "Microsoft"){
		msiestart = (navigator.appVersion.indexOf('(') + 1);
		msieend = navigator.appVersion.indexOf(')');
		msiestring = navigator.appVersion.substring(msiestart, msieend);
		msiearray = msiestring.split(";");
		platform = msiearray[2];
		msieversion = msiearray[1].split(" ");
		APP_VERSION = msieversion[2];
		isIE=true;
	}

	var linkMorg ="";
	var linkSawon ="";
	var posi_name="";
	
	var org_count="<%=org_count%>";
	var puser="<%=puser%>";
	//Change Buseo
	if(org_count > 0) linkMorg="<a href='javascript:changeMorg();' class='ic' title='부서변경'><span class='blind'>부서변경</span></a>";
	
	if(puser == "Y") linkSawon="<a href='javascript:dlogin();' class='ic' title='부서 직원 선택'><span class='blind'>부서 직원 선택</span></a>";
	
	//alert((new Date).getTime());
	
	function getCookie(value){
		var cookieName = value;
		var x, y;
		var val = document.cookie.split(';');
		var rtnVal = "";
		
		for(var i = 0; i < val.length; i++){
			x = val[i].substr(0, val[i].indexOf('='));
			y = val[i].substr(val[i].indexOf('=') + 1);
			x = x.replace(/^\s+|\s+$/g, ''); //공백제거
			if(x == cookieName){
				rtnVal = unescape(y);
			}
		}
		return rtnVal;
	}
	
	function setCookie(value, days){
		var cookieName = value;
		
		var exdate = new Date();
		exdate.setDate(exdate.getDate() + days);
		
		var cookieValue = escape(value) + ((days == null) ? '' : '; expires=' + exdate.toUTCString());
		document.cookie = cookieName + '=' + cookieValue;
	}
	
	
	var gap = Math.abs(getCookie("serverTime")) - (new Date()).getTime();
	
	function sessionTime(){
		var serverTime = Math.abs(getCookie("serverTime"));
		var sessionExpiry = Math.abs(getCookie("sessionExpiry"));
		var currTime = (new Date()).getTime();
		var time = sessionExpiry - currTime - gap;
		if(time<0) time=0;
		
		//var h = new Date(time).toTimeString();
		var sec = new Date(time).toISOString().split("T")[1].split(".")[0];
		
		$("#sessiontime").text(sec);
		setTimeout(sessionTime,1000);
	}

	function fnLoad(){
		setTimeout(sessionTime,1000);
		link_org.innerHTML=linkMorg;
		link_sawon.innerHTML=linkSawon;
		//posi.innerHTML=posi_name;
		//loadJoblist();
		if("<%=menu_id%>"!=""){
			menuTrigger("<%=menu_id%>"); 
		}
	}

	function getActiveTabIndex(){
		for(var i = 0;i < $("#myTab").children().length; i++){
			if($($("#myTab").children()[i]).hasClass("active")){
				return i;
			}
		}
	}
	
	var HELP_AD="";
	var helpwin=null;
	var contactwin=null;
	var PARTCODE = "";
	
	function changeMorg(){
		$("#winChgOrg").show();
	}
	
	function dlogin(){
		//$("#winSawon").show();
		orgEmpPopup();
	}
	
	function reLogin(){
		var f = document.loginfrm;
		WP.clearParameters();
		WP.setForm(f);

		var url = "<%=System.getProperty("contextpath")%>/login.do";
		var inputData = WP.getParams();

		WP.load(url, inputData,{
			success: function(result){
				if(result!='undefined'){
					if(result.message=="success"){
						var f = document.loginfrm;
						f.action = "<%=System.getProperty("contextpath")%>/main.do";
						f.target = "_self";
						f.submit();
					}else{
						alert(result.message);
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

	function drLogin(){
		var f = document.login2frm;
		WP.clearParameters();
		WP.setForm(f);

		var url = "<%=System.getProperty("contextpath")%>/login.do";
		var inputData = WP.getParams();

		WP.load(url, inputData,{
			success: function(result){
				if(result!='undefined'){
					if(result.message=="success"){
						var f = document.loginfrm;
						f.action = "<%=System.getProperty("contextpath")%>/main.do";
						f.target = "_self";
						f.submit();
					}else{
						alert(result.message);
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

	function menuClick(page_ad,help_ad,menu_nm,path,obj){
		if($.trim(page_ad) != ""){
			appendTab(page_ad,help_ad,menu_nm,path,obj);
		}
		$('#gnb > li , .snb-wrap').removeClass('on');
		$('.mega-menu-wrap').removeClass('on')
		$('#megaGnb').remove();
		$('#noticePop').hide();
	}

	function appendTab(page_ad,help_ad,menu_nm,path,obj){
		var menu_id = $(obj).data("menu-id");
		for(var i = 0;i < $("#myTab").children().length; i++){
			if($($("#myTab").children()[i]).attr("id")=="tab_"+menu_id){
				URL_LINK(page_ad,menu_nm,path,help_ad,obj);
				$($("#myTab").children()[i]).children("a").trigger("click");
				return;
			}
		}
		
		if($("#myTab").children().length>=10){
			alert("TAB은 10개 까지만 사용할 수 있습니다.");
			return;
		}else{
			var tab_html = "";
			//tab_html += '<li id="tab_'+menu_id+'" class="nav-item active">';
			tab_html += '<li id="tab_'+menu_id+'" class="nav-item">';
			tab_html += '<a class="nav-link" id="footer_tab'+menu_id+'" data-toggle="tab" href="#tab'+menu_id+'">'+menu_nm+'</a>';
			tab_html += '<button type="button" class="btn ico btn-close" onclick="javascript:deleteTab(this)"><i class="fa fa-times-circle"></i></button>';
			$("#myTab").append(tab_html);
			
			var content_html = "";
			//content_html += '<div id="tab'+menu_id+'" class="iframe-content tab-pane fade in active">';
			content_html += '<div id="tab'+menu_id+'" class="iframe-content tab-pane fade">';
			content_html += '<iframe name="ifrMain_'+menu_id+'" id="ifrmMain_'+menu_id+'" src="about:blank" width="100%" height="100%" scrolling="yes" frameborder="0"></iframe>';
			$("#myTabContent").append(content_html);
			$("#ifrmMain_"+menu_id).ready(function() {
				appendTab(page_ad,help_ad,menu_nm,path,obj);
				$("#ifrmMain_"+menu_id).focus(function(){
					$(".area-nav").trigger("click");
				});
			});
		}
	}

	function deleteTab(obj){
		if($("#myTab").children().length<=1){
			alert("TAB은 하나 이상 필요합니다.");
			return;
		}
		var id = $(obj).parent().attr("id");
		id =(""+id).replace("_","");
		$("#"+id).remove();
		$(obj).parent().remove();
		for(var i = 0;i < $("#myTab").children().length; i++){
			if($($("#myTab").children()[i]).hasClass("active")){
				return;
			}
			if(i==$("#myTab").children().length-1){
				$($("#myTab").children()[i]).children("a").trigger("click");
			}
		}
	}

	var MAINTITLE;
	var HISTORY;
	var MENUOBJECT;
	
	function URL_LINK(url,t,h,help,obj){
		HELP_AD=help;
		MAINTITLE=t;
		HISTORY=h;
		POPUP_COUNT=0;
		var html = "" ;
		var act = url.split("?");
		var params = url.replace(act[0]+"?","").split("&");
		for(var i=0;i<params.length;i++){
			var op = params[i].split("=");
			html+='<input name="'+op[0]+'" type="hidden" value="'+op[1]+'" />';
		}
		$("#menuform").html(html);
		var f = document.setmenuform;
		f.menu_id.value = $(obj).data("menu-id");
		WP.clearParameters();
		WP.setForm(f);
		
		var url = "<%=System.getProperty("contextpath")%>/SetMenu.do";
		var inputData = WP.getParams();
		
		WP.sync_load(url, inputData,{
			success: function(result){
				//alert(result.rtnCode);
				if(result!='undefined' && result.rtnCode=="0"){
				}
			},
			  
			complete: function(statusText,status) {
			},
			  
			error: function(rtnMsg){
				alert(JSON.stringify(rtnMsg));
			}
		});
		
		var f = document.menuform;
		f.action=act[0];
		f.target="ifrMain_"+$(obj).data("menu-id");
		f.submit();
		
		$("#tab_"+$(obj).data("menu-id")).trigger("click");
		
		$(".area-nav").trigger("click");
		$(window).trigger("resize");
		
		MENUOBJECT = obj;
		
	}
	
	var SYSDATE="<%=SYSDATE%>";;
	var SCHEDULE_FIELD="<%=SCHEDULE_FIELD%>";
	function datacomplete(){
		SYSDATE=menu_bar1.getTopAttributes()["sysdate"];
		SCHEDULE_FIELD = getScheduleFlag();
	}

	function getMenunode(menu_id){
		
		var all = $("#gnb").find('li');
		for(var i=0;i<all.length;i++){
			if($(all[i]).data("menu-id")==menu_id) return $(all[i]);
		}
		
		return null;			
	}

	function isMenuAlive(menu_id){
		if(menu_id=="") return false;
		var selector = getMenunode(menu_id); //데이터 수정
		if(selector!=null){
			return true;
		}else{
			return false;
		}
	}

	function menuTrigger(menu_id){
		if(menu_id=="") return;
		var selector = getMenunode(menu_id); //데이터 수정
		if(selector!=null){
			//alert($(selector).html());
			$(selector).trigger("click");
		}else{
//			alert("권한이 없습니다.");
		}
	}

	function userLogout(){
		if(!confirm("Log out from ORMS system?")){
			return false;
		}
		var f = document.logoutform;
		WP.clearParameters();
		WP.setForm(f);
		
		var url = "<%=System.getProperty("contextpath")%>/Jsp.do";
		var inputData = WP.getParams();
		showLoadingWs(); // 프로그래스바 활성화
		
		WP.load(url, inputData,{
			success: function(result){
				//alert(result.rtnCode);
				if(result!='undefined' && result.rtnCode=="0"){
					//window.close();
					window.open("about:blank", "_self").close();
				}
			},
			  
			complete: function(statusText,status) {
				removeLoadingWs();
			},
			  
			error: function(rtnMsg){
				alert(JSON.stringify(rtnMsg));
			}
		});
		
	}

	function userReload(){
		if(!confirm("ReLoad Comm(XML) Manager ?")){
			return false;
		}
		var f = document.reloadform;
		WP.clearParameters();
		WP.setForm(f);
		
		var url = "<%=System.getProperty("contextpath")%>/reloadxml.do";
		var inputData = WP.getParams();
		showLoadingWs(); // 프로그래스바 활성화
		
		WP.load(url, inputData,{
			success: function(result){
				//alert(result.rtnCode);
				if(result!='undefined' && result.rtnCode=="0"){
					alert("ReLoad OK");
				}
			},
			  
			complete: function(statusText,status) {
				removeLoadingWs();
			},
			  
			error: function(rtnMsg){
				alert(JSON.stringify(rtnMsg));
			}
		});
	}

	$("#sitemap").ready(function() {
		$("#sitemap").click(function() {
			$("#naviArea").hide();
			
			ifrMain.location.href="<%=System.getProperty("contextpath")%>/sitemap.do";
			$(window).trigger("resize");
		});
	});

	function dropdownMenu(obj){
		$(obj).children(".dropdown-menu").css("left", -($(obj).offset().left)+"px");
		$(obj).children(".dropdown-menu").css("top", ($(obj).height())+"px");
	}	
// 
	var brcdata = {Data:[
	<%
	for(int i=0; i<vBrList.size(); i++){
		HashMap hBrMap = (HashMap)vBrList.get(i);
		
	%>
	<%=(i==0)?"":","%>{grp_org_c:"<%=hBrMap.get("grp_org_c")%>", grp_orgnm:"<%=hBrMap.get("grp_orgnm")%>", brc:"<%=hBrMap.get("brc")%>", brnm:"<%=hBrMap.get("brnm")%>"}
	<%
	}
	%>
	                     ]};

	$(document).ready(function(){
		initIBSheet();
	});
	
	function initIBSheet() {
		mySheet.Reset();
		var initData = {};
		
		initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": sizeNoHScroll, "MouseHoverMode": 0, "DragMode":1, DeferredVScroll:1,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden"};
		initData.Cols = [
				{Header:"그룹기관코드",	Type:"Text",	SaveName:"grp_org_c",			Hidden:true},
				{Header:"사명",		Type:"Text",	SaveName:"grp_orgnm",		Width:125,	MinWidth:150},
				{Header:"부서코드",	Type:"Text",	SaveName:"brc",			Hidden:true},
				{Header:"부서명",		Type:"Text",	SaveName:"brnm",		Width:125,	MinWidth:150}
			];
		IBS_InitSheet(mySheet,initData);
		
		mySheet.SetEditable(0); //수정불가
		mySheet.SetCountPosition(0);
		mySheet.SetSelectionMode(4);
		
		doAction('search');
		
	}

	function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
		if(Row >= mySheet.GetDataFirstRow()){
			$("form[name=loginfrm] [name=grp_org_c]").val(mySheet.GetCellValue(Row, "grp_org_c"));
			$("form[name=loginfrm] [name=partcode]").val(mySheet.GetCellValue(Row, "brc"));
			doAction('select')
		}
	}
	
	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
		if(Row >= mySheet.GetDataFirstRow()){
			$("form[name=loginfrm] [name=grp_org_c]").val(mySheet.GetCellValue(Row, "grp_org_c"));
			$("form[name=loginfrm] [name=partcode]").val(mySheet.GetCellValue(Row, "brc"));
		}
	}

	function mySheet_OnSelectCell(OldRow, OldCol, Row, Col,isDelete) {
		if(Row >= mySheet.GetDataFirstRow()){
			$("form[name=loginfrm] [name=grp_org_c]").val(mySheet.GetCellValue(Row, "grp_org_c"));
			$("form[name=loginfrm] [name=partcode]").val(mySheet.GetCellValue(Row, "brc"));
		}
	}

	function doAction(sAction) {
		switch(sAction) {
			case "search":  //데이터 조회
				mySheet.LoadSearchData(brcdata);
		
				break;
			case "select": //부서 선택
				if($("#partcode").val() == ""){
					alert("부서를 선택해 주십시오.");
					return;
				}
				reLogin()			
				
				break;
		}
	}


	// GNB
	function megaMenuView(){
		$('#gnb').clone().appendTo('.mega-menu-wrap').attr('id', 'megaGnb');
		$('#megaGnb').removeClass('gnb').addClass('mega-gnb');
	}
	function megaMenuHide(){
		$('#megaGnb').remove();
	}
	$("#gnb").ready(function() {
		$('#gnb > li , .snb-wrap').on('mouseenter', function(){
			$(this).addClass('on');
		}).on('mouseleave', function(){
			$(this).removeClass('on');
		})
		// 메가메뉴 컨트롤 
		$('.btn-mega').on('click', function (){
			$('.mega-menu-wrap').toggleClass('on');
			if( $('.mega-menu-wrap').hasClass('on') ){
				megaMenuView();
			}else{
				megaMenuHide();
			}
		});
	});
	
	
	// 현재날짜시간 표시
	function printNow(){
		var now = new Date();
		
		var year = now.getFullYear();
		var month = ('0' + (now.getMonth() + 1)).slice(-2);
		var day = ('0' + now.getDate()).slice(-2);
		
		var weeks = ['일', '월', '화', '수', '목', '금', '토'];
		var dayOfWeek = weeks[now.getDay()];
		
		var hours = ('0' + now.getHours()).slice(-2);
		var minutes = ('0' + now.getMinutes()).slice(-2);
		var seconds = ('0' + now.getSeconds()).slice(-2);
		
		var dateString = year + '.' + month + '.' + day + ' (' + dayOfWeek + ')';
		var timeString = hours + ':' + minutes + ':' + seconds;
		
		document.querySelector('#now_date').innerText = dateString;
		document.querySelector('#now_time').innerText = timeString;
	}

	</script>
</head>
<body onload="fnLoad();">
	<div class="wrapper">

		<%-- .header-wrap --%>
		<div class="header-wrap">

			<%-- header --%>
			<header class="header">

				<h1 class="header-brand">
					<a href="<%=System.getProperty("contextpath")%>/main.do" class="navbar-brand">
						<%-- <img src="<%=System.getProperty("contextpath")%>/images/logo<%=grp_org_c%>.png" alt="운영리스크 관리시스템 브랜드이미지" /> --%>
						<img src="<%=System.getProperty("contextpath")%>/imgs/logo.png" alt="운영리스크 관리시스템 브랜드이미지">
						<b>운영리스크 관리시스템</b>
					</a>
				</h1>
				
				<div class="header-today">
					<p class="today">
						<span id="now_date" class="date">2000.00.00 (-)</span>
						<span id="now_time" class="time">00:00:00</span>
					</p>
					<%-- session Tome --%>
					<p class="session-time">
						<span id="sessiontime" class="time">00:00:00</span>
					</p>
				</div>

				<ul class="header-user">
					<%-- User Menu --%>
					<%-- 
					<li class="user-check">
						<span class="checkbox-custom">
							<input type="checkbox" name="sCheck12" id="usedtab" value="Y">
							<label for="usedtab"><i></i><span>Used TAB</span></label>
						</span>
					</li> --%>
					<%-- User Menu --%>
					<li class="user-menu">
						<i class="fa fa-user"></i>
						<span class="user-company"><%=grp_orgnm %> &middot; <%=brnm%></span>
						<span class="user-name"><%=empnm%></span>
						<span class="user-num"><%=userid%></span>
					</li>
					<%-- Icon Button  
					<li class="ic-btn help">
						<a href="#" class="ic" title="HELP"><span class="blind">HELP</span></a>
					</li>
					--%>
					<%-- 부서변경 --%>
					<li class="ic-btn buseo" id="link_org">
						<!-- <a href="#" class="ic" title="부서변경"><span class="blind">부서변경</span></a> -->
					</li>
					<%-- 부서 직원 선택 --%>
					<li class="ic-btn sawon" id="link_sawon">
						<!-- <a href="#" class="ic" title="부서 직원 선택"><span class="blind">부서 직원 선택</span></a> -->
					</li>
					<%-- xml reload --%>
					<%if("Y".equals(puser)){ %>
					<li class="ic-btn reload">
						<a id="reload" href="javascript:userReload();" class="ic" title="xml reload"><span class="blind">xml reload</span></a>
					</li>
					<%} %>
					<li class="ic-btn logout">
						<a id="logout" href="javascript:userLogout();" class="ic" title="로그아웃"><span class="blind">로그아웃</span></a>
					</li>
				</ul>
			</header>
			<%-- header //--%>

			<%-- gnb --%>
			<div class="gnb-wrap">
				<nav class="area-gnb">
					<ul id="gnb" class="gnb">
						<%
							int save_level = 0;

							HashMap mnuMap = null;
							// Last Level check
							int last_lvl = -1;
							for (int i = 0; i < vMnuList.size(); i++) {
								mnuMap = (HashMap) vMnuList.get(i);
								//System.out.println("mnuMap"+mnuMap.toString());

								int current_level = Integer.parseInt((String) mnuMap.get("lvl"));
								if (current_level == 2)
									last_lvl = i;
								mnuMap.put("connect_by_isleaf", "0");
								if (current_level <= save_level) {
									((HashMap) vMnuList.get(i - 1)).put("connect_by_isleaf", "1");
								}

								save_level = current_level;
							}

							if (!vMnuList.isEmpty())
								((HashMap) vMnuList.get(vMnuList.size() - 1)).put("connect_by_isleaf", "1");

							if (last_lvl != -1) {
								mnuMap = (HashMap) vMnuList.get(last_lvl);
								mnuMap.put("last_2lvl", "Y");
							}
							boolean first_flag = true;
							boolean last_flag = false;
							save_level = 2;
							for (int i = 0; i < vMnuList.size(); i++) {
								mnuMap = (HashMap) vMnuList.get(i);
								int current_level = Integer.parseInt((String) mnuMap.get("lvl"));
								//if(current_level>4) continue;
								int connect_by_isleaf = Integer.parseInt((String) mnuMap.get("connect_by_isleaf"));//0:있음,1:없음
								String mnnm = (String) mnuMap.get("mnnm");
								String path = (String) mnuMap.get("mpath");

								//System.out.println("mnuMap.toString() :::: " + mnuMap.toString());

								if (current_level < save_level) {
									for (int j = save_level; j > current_level; j--) {
										if (j >= 3) {
						%>
					</ul>
					</li>
					<%
						}
								}
							}
							if (current_level >= 2) {
								if (current_level > save_level) {
									if (current_level >= 3) {
										if (current_level == 3) {
					%>
					<ul class="snb">
						<%
							} else {
						%>
						<ul class="snb2">
							<%
								}
											}
										}

										boolean checkUseMenu = false;
										String schedule_field_value = (String) mnuMap.get(SCHEDULE_FIELD);

										if (schedule_field_value == null || schedule_field_value.equals("")
												|| schedule_field_value.equals("Y")) {
											checkUseMenu = true;
										}

										String page_ad = System.getProperty("contextpath") + (String) mnuMap.get("urlnm");
										String help_ad = System.getProperty("contextpath") + (String) mnuMap.get("help_ad");
										if (help_ad == null)
											help_ad = "";

										String title = "";
										if (!checkUseMenu) {
											page_ad = "";
											if (SCHEDULE_FIELD.equals("evl_tm_use_yn")) {
												title = "평가기간중에는 사용할 수 없습니다. ";
											}
											if (SCHEDULE_FIELD.equals("cls_tm_use_yn")) {
												title = "마감기간중에는 사용할 수 없습니다. ";
											}
											if (SCHEDULE_FIELD.equals("rgs_tm_use_yn")) {
												title = "등록기간중에는 사용할 수 없습니다. ";
											}
											if (SCHEDULE_FIELD.equals("etc_tm_use_yn")) {
												title = "이기간중에는 사용할 수 없습니다. ";
											}
										}

										String info_link = "";

										if (connect_by_isleaf == 1) {
							%>
							<li
								onClick="menuClick('<%=page_ad%>','<%=help_ad%>','<%=(String) mnuMap.get("mnnm")%>','<%=path%>',this);try{event.stopPropagation();}catch(err){};return false;"
								data-menu-id="<%=(String) mnuMap.get("menu_id")%>"
								data-page-ad="<%=page_ad%>" data-help-ad="<%=help_ad%>"
								data-path="<%=path%>" title=""><a href="#" class="dep3"><%=((String) mnuMap.get("mnnm")).replaceAll("&", "&amp;")%></a>
							</li>
							<%
								} else {
											if (current_level == 2) {
							%>
							<li><a href="#" class="dep1"><%=((String) mnuMap.get("mnnm")).replaceAll("&", "&amp;")%></a>
								<div class="snb-wrap">
									<p class="title"><%=((String) mnuMap.get("mnnm")).replaceAll("&", "&amp;")%></p>
									<%
										} else {
									%>
									<li data-menu-id="<%=(String) mnuMap.get("menu_id")%>"
										data-page-ad="<%=page_ad%>" data-help-ad="<%=help_ad%>"
										data-path="<%=path%>" title="">
										<p class="dep2"><%=((String) mnuMap.get("mnnm")).replaceAll("&", "&amp;")%></p>
										<%
											}
														first_flag = false;
										%> <%
 	}
 		}
 		save_level = current_level;
 	}

 	if (!vMnuList.isEmpty()) {
 		if (1 < save_level) {
 			for (int j = save_level; j > 1; j--) {
 				if (j >= 3) {
 %>
									
						</ul>
						</li>
						<%
							}
									}
								}
							}
						%>
					</ul>
				</nav>
			</div>
			<%-- gnb //--%>

			<%-- mega-menu --%>
			<nav class="mega-menu-wrap">
				<button class="btn-mega" title="전체메뉴">
					<p class="mega-open">
						<i class="fa fa-bars"></i> <span class="blind">열기</span>
					</p>
					<p class="mega-close">
						<i class="fa fa-close"></i> <span class="blind">닫기</span>
					</p>
				</button>
			</nav>
			<%-- mega-menu //--%>

		</div>
		<%-- .header-wrap //--%>



		<%-- .content-wrapper --%>
		<div id="myTabContent" class="content-wrapper tab-content"></div>
		<%-- .content-wrapper // --%>
		<footer class="footer">
			<div class="footer-bar">
				<ul class="nav nav-tabs footer-tabs" id="myTab" role="tablist">
				</ul>
				<%-- 
				<div class="group-copy">&copy;--Copyrights--<strong>DGB Financial Group</strong>. All rights		reserved.
				</div>--%>
			</div>
			<%-- /.container --%>
		</footer>
	</div>
	<%-- ./wrapper --%>
	<div id="winChgOrg" class="popup modal">
		<div class="p_frame">
			<div class="p_head">
				<h3 class="title md">부서 변경</h3>
			</div>
			<div class="p_body">
				<div class="p_wrap">
					<div class="box box-grid">
						<div class="box-body">
							<div class="wrap-grid h150">
								<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%"); </script>
							</div>
						</div>
					</div>
				</div>
				<%-- p_wrap //--%>
			</div>
			<div class="p_foot">
				<div class="btn-wrap">
					<button type="button" class="btn btn-primary" onclick="javascript:doAction('select');">선택</button>
					<button type="button" class="btn btn-default btn-pclose">취소</button>
				</div>
			</div>
			<button type="button" class="ico close fix btn-close">
				<span class="blind">닫기</span>
			</button>
		</div>
		<div class="dim p_close"></div>
	</div>
	<%-- popup //--%>
	<div id="winSawon" class="popup modal">
		<div class="p_frame w300">
			<div class="p_head">
				<h3 class="title">로그인</h3>
			</div>
			<div class="p_body">
				<div class="p_wrap">
					<%-- 조회 --%>
					<div class="box box-search">
						<div class="box-body">
							<div class="wrap-search">
								<table>
									<colgroup>
										<col />
									</colgroup>
									<tbody>
										<tr>
											<td>
												<%-- 
												<form name="login2frm" method="post" >
												<input type="text" class="form-control w100" id="userid" name="userid" value="" placeholder="사원번호" onkeypress="EnterkeySubmit(drLogin,null);"/>
												</form> --%>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
							<%-- .wrap-search --%>
						</div>
						<%-- .box-body //--%>
						<div class="box-footer">
							<button type="button" class="btn btn-primary search"
								onClick="javascript:drLogin();">로그인</button>
						</div>
					</div>
					<%-- .box-search //--%>
				</div>
				<%-- p_wrap //--%>
			</div>
			<div class="p_foot">
				<div class="btn-wrap">
					<button type="button" class="btn btn-default btn-pclose">취소</button>
				</div>
			</div>
			<button type="button" class="ico close fix btn-close">
				<span class="blind">닫기</span>
			</button>
		</div>
		<div class="dim p_close"></div>
	</div>
	<%-- popup //--%>
	<!-- 공지사항 팝업 -->
	<div id="notice_area"></div>
	
	<script src="<%=System.getProperty("contextpath")%>/js/jquery.min.js"></script>
	<script src="<%=System.getProperty("contextpath")%>/js/bootstrap.min.js"></script>

	<script>
		$(document).ready(function(){
			// 사이드메뉴 컨트롤 
			$('.btn-mega').click(function (){
				$('.nav-mega').stop().toggleClass('on');
				$('.mega-menu').stop().toggleClass('on');
			});
			
			// 현재날짜시간 표시
			printNow();
			setInterval('printNow()', 1000);
			
		});
	</script>

	<form name="mainform" method="post" style="display: none;">
		<input name="partcode" type="hidden" value="" /> <input name="title" type="hidden" value="100" />
	</form>
	<form name="logoutform" method="post" style="display: none;">
		<input name="path" type="hidden" value="/main/logout" />
	</form>
	<form name="setmenuform" method="post" style="display: none;">
		<input name="menu_id" type="hidden" value="" />
	</form>
	<form name="subform" method="post" style="display: none;">
		<input name="method" type="hidden" value="" />
		<input name="commkind" type="hidden" value="/main/logout" />
		<input name="process_id" type="hidden" value="" />
	</form>
	<form id="menuform" name="menuform" method="post" style="display: none;"></form>
	<form name="loginfrm" method="post">
		<input type="hidden" id="grp_org_c" name="grp_org_c" value="" />
		<input type="hidden" id="partcode" name="partcode" value="" />
	</form>
	<form name="reloadform" method="post"></form>
	<form name="login2frm" method="post">
		<input type="hidden" id="userid" name="userid" value="" />
	</form>
	<%@ include file="../comm/OrgEmpInfP.jsp"%>
	<%-- 부서별직원 공통 팝업 --%>
	<script>
		function orgEmpPopup(){
			schOrgEmpPopup("empSearchEnd");
			$("#ifrOrgEmp").get(0).contentWindow.doAction("orgSearch");
		}

		// 직원검색 완료
		function empSearchEnd(eno, empnm){
			$("#userid").val(eno);
			//$("#usernm").val(empnm);
			closeBuseoEmp();
			drLogin();
			//doAction('search');
		}
		
		$(document).ready(function(){
			//닫기
			$(".btn-close").click( function(event){
				//$("#winBuseo",parent.document).hide();
				$("#winChgOrg").hide();
				$("#winSawon").hide();
				event.preventDefault();
				
			});
			
			popupNtcbrd();
		});
			
		function closePop(){
			//$("#ifrOrg",parent.document).attr("src","about:blank");
			//$("#winBuseo",parent.document).hide();
			$("#winChgOrg").hide();
			$("#winSawon").hide();
		}
		//취소
		$(".btn-pclose").click( function(){
			$("#partcode").val("");
			$("#userid").val("");
			closePop();
		});
		
		function closeNotice(blbd_sqno){
			if(document.getElementById('chkNotice').checked == true){
				setCookie("noticePop"+blbd_sqno, 1);
			}
			document.getElementById('noticePop').style.display = "none";
		}
		
		function popupNtcbrd(){	//공지사항 팝업
			
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "com");
			WP.setParameter("process_id", "ORCO090701");
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			
// 			alert(inputData);
// 			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,{
				success: function(result){
					var rList = result.DATA;
					if(result != 'undefined' && result.DATA != '') {
						if(getCookie("noticePop"+parseInt(result.DATA[0].blbd_sqno)) == ""){ 
							//var win = window.open("","popntcbrd"+rList[i].blbd_sqno,"width=430,height=430,resizable=no");
							var nHtml = "";
							nHtml += "<article class='notice-pop' id='noticePop' style='display:block'>";
							nHtml += "	<h2 class='notice-title'>"+result.DATA[0].blbd_tinm+"</h2>";
							nHtml += "	<div class='notice-content'>"+result.DATA[0].blbd_cntn+"</div>";
							nHtml += "	<div class='notice-button'>";
							nHtml += "		<span class='checkbox-custom'>";
							nHtml += "			<input type='checkbox' name='chkNotice' id='chkNotice' class='checkbox'>";
							nHtml += "			<label for='chkNotice'><i></i><span>24시간 동안 보지 않기</span></label>";
							nHtml += "		</span>";
							nHtml += "		<button type='button' class='btn btn-default btn-xs' onclick='closeNotice("+parseInt(result.DATA[0].blbd_sqno)+")'><span class='txt'>닫기</span></button>";
							nHtml += "	</div>";
							nHtml += "</articel>";
							$("#notice_area").html(nHtml);
						}
					}
				},
			  
				complete: function(statusText,status){
				},
			  
				error: function(rtnMsg){
				}
			});
			
		}
		
	</script>
</body>
</html>