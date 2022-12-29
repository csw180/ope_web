<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String pageName_wk = request.getServletPath();
	int pageNameIndex_wk = pageName_wk.lastIndexOf("/");
	pageName_wk = (pageName_wk.substring(pageNameIndex_wk+1, pageName_wk.length())).replace(".jsp", "");
%>
	<script>
	$(".page-header").ready(function() {
		$("#title").html(parent.MAINTITLE+'['+"<%=pageName_wk%>"+']');
		var title = parent.HISTORY.split(">");

		$("#path0").html($.trim(title[1]));
		$("#path1").html($.trim(title[2]));
		
		var childrens = $(parent.MENUOBJECT).parent().children();
		
		var html_select = "";
		var html_list = '<ul class="dropdown-menu">';
		var submenu_cnt = 0;

		for(var i=0 ; i<childrens.length;i++){
			if(parent.MENUOBJECT==childrens[i]){
				html_list += '<li class="active"><a href="#">';
				html_select += '<a class="dropdown-toggle" data-toggle="dropdown" href="#">';
				html_select += $(childrens[i]).text();
				html_select += '<span class="caret"></span></a>';
				submenu_cnt++;
			}else{
				html_list += '<li><a href="javascript:parent.menuTrigger(\'' + $(childrens[i]).data("menu-id") + '\')">';
			}
			html_list += $(childrens[i]).text() + '</a></li>';
		}
		
		html_list += '</ul>';

		$("#sub_menu").html(html_select+html_list);
		
	});
	
	function alarm(){
		var f = document.ormsForm;
		WP.clearParameters();
		WP.setParameter("method", "Main");
		WP.setParameter("commkind", "com"); 
		WP.setParameter("process_id", "ORCO011501");  
		WP.setForm(f);
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		var inputData = WP.getParams();
		
		showLoadingWs(); // 프로그래스바 활성화
		WP.load(url, inputData,
		    {
			  success: function(result){
				  if(result != 'undefined' && result.rtnCode== '0'){
					   var rList = result.DATA;
					   var add_html = "";
					   var temp = "";
					   //alert(document.cookie);
					   
					   //00 : 평가기간이 아님
					  /*  var rk_stsc = rList[0].rk_stsc;
					   var rki_stsc = rList[0].rki_stsc; */
					   var rep_stsc = rList[0].rep_stsc;
					   var bia_stsc = rList[0].bia_stsc;
					   var ra_stsc = rList[0].ra_stsc;
					   
					  /*  if(rk_stsc == '01' && !(document.cookie.includes(rList[0].bas_ym+"rk"))){ 
					   		add_html += '<ul class="alarm-list">';
					   		add_html += '<li><button type="button" class="btn-alarm-list" title="바로가기" onclick="javascript:menu_location('+"'rk"+rk_stsc+"'"+');">RCSA 평가자 지정이 완료되지 않았습니다. (평가 기한 이내에 평가자 지정을 완료해 주십시오.)</button></li>';
					   		add_html += '</ul>';
					   		temp += rList[0].bas_ym + 'rk';
					   }else if(rk_stsc == '01' && document.cookie.includes(rList[0].bas_ym+"rk")){
						    add_html += '<ul class="alarm-list2">';
					   		add_html += '<li><button type="button" class="btn-alarm-list" title="바로가기" onclick="javascript:menu_location('+"'rk"+rk_stsc+"'"+');">RCSA 평가자 지정이 완료되지 않았습니다. (평가 기한 이내에 평가자 지정을 완료해 주십시오.)</button></li>';
					   		add_html += '</ul>';   
					   		temp += rList[0].bas_ym + 'rk';
					   }else if(rk_stsc == '04' || rk_stsc == '13' || rk_stsc == '14' || rk_stsc == '15' || rk_stsc == '16' && !(document.cookie.includes(rList[0].bas_ym+"rk"))){ //부서팀장, orm, orm팀장, bcp, bcp팀장이 확인
					   		add_html += '<ul class="alarm-list">';
					   		add_html += '<li><button type="button" class="btn-alarm-list" title="바로가기" onclick="javascript:menu_location('+"'rk"+rk_stsc+"'"+');">RCSA 평가 결과 검토가 완료되지 않았습니다. (평가 기한 이내에 검토를 완료해 주세요.)</button></li>';
					   		add_html += '</ul>';
					   		temp += rList[0].bas_ym + 'rk';
					   }else if(rk_stsc == '04' || rk_stsc == '13' || rk_stsc == '14' || rk_stsc == '15' || rk_stsc == '16' && document.cookie.includes(rList[0].bas_ym+"rk")){
						    add_html += '<ul class="alarm-list2">';
					   		add_html += '<li><button type="button" class="btn-alarm-list" title="바로가기" onclick="javascript:menu_location('+"'rk"+rk_stsc+"'"+');">RCSA 평가 결과 검토가 완료되지 않았습니다. (평가 기한 이내에 검토를 완료해 주세요.)</button></li>';
					   		add_html += '</ul>';   
					   		temp += rList[0].bas_ym + 'rk';
					   }
					   
					   if(rki_stsc == '01' && !(document.cookie.includes(rList[0].bas_ym+"rki"))){ 
					   		add_html += '<ul class="alarm-list">';
					   		add_html += '<li><button type="button" class="btn-alarm-list" title="바로가기" onclick="javascript:menu_location('+"'rki"+rki_stsc+"'"+');">KRI 평가자 지정이 완료되지 않았습니다. (평가 기한 이내에 평가자 지정을 완료해 주십시오.)</button></li>';
					   		add_html += '</ul>';
					   		temp += rList[0].bas_ym + 'rki';
					   }else if(rki_stsc == '01' && document.cookie.includes(rList[0].bas_ym+"rki")){
						    add_html += '<ul class="alarm-list2">';
					   		add_html += '<li><button type="button" class="btn-alarm-list" title="바로가기" onclick="javascript:menu_location('+"'rki"+rki_stsc+"'"+');">KRI 평가자 지정이 완료되지 않았습니다. (평가 기한 이내에 평가자 지정을 완료해 주십시오.)</button></li>';
					   		add_html += '</ul>';   
					   		temp += rList[0].bas_ym + 'rki';
					   }else if(rki_stsc == '04' || rki_stsc == '13' || rki_stsc == '14' || rki_stsc == '15' || rki_stsc == '16' && !(document.cookie.includes(rList[0].bas_ym+"rki"))){ //부서팀장, orm, orm팀장, bcp, bcp팀장이 확인
					   		add_html += '<ul class="alarm-list">';
					   		add_html += '<li><button type="button" class="btn-alarm-list" title="바로가기" onclick="javascript:menu_location('+"'rki"+rki_stsc+"'"+');">KRI 평가 결과 검토가 완료되지 않았습니다. (평가 기한 이내에 검토를 완료해 주세요.)</button></li>';
					   		add_html += '</ul>';
					   		temp += rList[0].bas_ym + 'rki';
					   }else if(rki_stsc == '04' || rki_stsc == '13' || rki_stsc == '14' || rki_stsc == '15' || rki_stsc == '16' && document.cookie.includes(rList[0].bas_ym+"rki")){
						    add_html += '<ul class="alarm-list2">';
					   		add_html += '<li><button type="button" class="btn-alarm-list" title="바로가기" onclick="javascript:menu_location('+"'rki"+rki_stsc+"'"+');">KRI 평가 결과 검토가 완료되지 않았습니다. (평가 기한 이내에 검토를 완료해 주세요.)</button></li>';
					   		add_html += '</ul>';   
					   		temp += rList[0].bas_ym + 'rki';
					   }
					    */
					   if(rep_stsc == '01' && !(document.cookie.includes(rList[0].bas_ym+"rep"))){ 
					   		add_html += '<ul class="alarm-list">';
					   		add_html += '<li><button type="button" class="btn-alarm-list" title="바로가기" onclick="javascript:menu_location('+"'rep"+rep_stsc+"'"+');">평판 평가자 지정이 완료되지 않았습니다. (평가 기한 이내에 평가자 지정을 완료해 주십시오.)</button></li>';
					   		add_html += '</ul>';
					   		temp += rList[0].bas_ym + 'rep';
					   }else if(rep_stsc == '01' && document.cookie.includes(rList[0].bas_ym+"rep")){
						    add_html += '<ul class="alarm-list2">';
					   		add_html += '<li><button type="button" class="btn-alarm-list" title="바로가기" onclick="javascript:menu_location('+"'rep"+rep_stsc+"'"+');">평판 평가자 지정이 완료되지 않았습니다. (평가 기한 이내에 평가자 지정을 완료해 주십시오.)</button></li>';
					   		add_html += '</ul>';   
					   		temp += rList[0].bas_ym + 'rep';
					   }else if(rep_stsc == '04' || rep_stsc == '13' || rep_stsc == '14' || rep_stsc == '15' || rep_stsc == '16' && !(document.cookie.includes(rList[0].bas_ym+"rep"))){ //부서팀장, orm, orm팀장, bcp, bcp팀장이 확인
					   		add_html += '<ul class="alarm-list">';
					   		add_html += '<li><button type="button" class="btn-alarm-list" title="바로가기" onclick="javascript:menu_location('+"'rep"+rep_stsc+"'"+');">평판 평가 결과 검토가 완료되지 않았습니다. (평가 기한 이내에 검토를 완료해 주세요.)</button></li>';
					   		add_html += '</ul>';
					   		temp += rList[0].bas_ym + 'rep';
					   }else if(rep_stsc == '04' || rep_stsc == '13' || rep_stsc == '14' || rep_stsc == '15' || rep_stsc == '16' && document.cookie.includes(rList[0].bas_ym+"rep")){
						    add_html += '<ul class="alarm-list2">';
					   		add_html += '<li><button type="button" class="btn-alarm-list" title="바로가기" onclick="javascript:menu_location('+"'rep"+rep_stsc+"'"+');">평판 평가 결과 검토가 완료되지 않았습니다. (평가 기한 이내에 검토를 완료해 주세요.)</button></li>';
					   		add_html += '</ul>';   
					   		temp += rList[0].bas_ym + 'rep';
					   }
					   
					   if(bia_stsc == '02' && !(document.cookie.includes(rList[0].bas_ym+"bia"))){ 
					   		add_html += '<ul class="alarm-list">';
					   		add_html += '<li><button type="button" class="btn-alarm-list" title="바로가기" onclick="javascript:menu_location('+"'bia"+bia_stsc+"'"+');">BIA 평가자 지정이 완료되지 않았습니다. (평가 기한 이내에 평가자 지정을 완료해 주십시오.)</button></li>';
					   		add_html += '</ul>';
					   		temp += rList[0].bas_ym + 'bia';
					   }else if(bia_stsc == '01' && document.cookie.includes(rList[0].bas_ym+"bia")){
						    add_html += '<ul class="alarm-list2">';
					   		add_html += '<li><button type="button" class="btn-alarm-list" title="바로가기" onclick="javascript:menu_location('+"'bia"+bia_stsc+"'"+');">BIA 평가자 지정이 완료되지 않았습니다. (평가 기한 이내에 평가자 지정을 완료해 주십시오.)</button></li>';
					   		add_html += '</ul>';   
					   		temp += rList[0].bas_ym + 'bia';
					   }else if(bia_stsc == '04' || bia_stsc == '13' || bia_stsc == '14' || bia_stsc == '15' || bia_stsc == '16' && !(document.cookie.includes(rList[0].bas_ym+"bia"))){ //부서팀장, orm, orm팀장, bcp, bcp팀장이 확인
					   		add_html += '<ul class="alarm-list">';
					   		add_html += '<li><button type="button" class="btn-alarm-list" title="바로가기" onclick="javascript:menu_location('+"'bia"+bia_stsc+"'"+');">BIA 평가 결과 검토가 완료되지 않았습니다. (평가 기한 이내에 검토를 완료해 주세요.)</button></li>';
					   		add_html += '</ul>';
					   		temp += rList[0].bas_ym + 'bia';
					   }else if(bia_stsc == '04' || bia_stsc == '13' || bia_stsc == '14' || bia_stsc == '15' || bia_stsc == '16' && document.cookie.includes(rList[0].bas_ym+"bia")){
						    add_html += '<ul class="alarm-list2">';
					   		add_html += '<li><button type="button" class="btn-alarm-list" title="바로가기" onclick="javascript:menu_location('+"'bia"+bia_stsc+"'"+');">BIA 평가 결과 검토가 완료되지 않았습니다. (평가 기한 이내에 검토를 완료해 주세요.)</button></li>';
					   		add_html += '</ul>';   
					   		temp += rList[0].bas_ym + 'bia';
					   }
					   
					   if(ra_stsc == '01' && !(document.cookie.includes(rList[0].bas_ym+"ra"))){ 
					   		add_html += '<ul class="alarm-list">';
					   		add_html += '<li><button type="button" class="btn-alarm-list" title="바로가기" onclick="javascript:menu_location('+"'ra"+ra_stsc+"'"+');">RA 평가자 지정이 완료되지 않았습니다. (평가 기한 이내에 평가자 지정을 완료해 주십시오.)</button></li>';
					   		add_html += '</ul>';
					   		temp += rList[0].bas_ym + 'ra';
					   }else if(ra_stsc == '01' && document.cookie.includes(rList[0].bas_ym+"ra")){
						    add_html += '<ul class="alarm-list2">';
					   		add_html += '<li><button type="button" class="btn-alarm-list" title="바로가기" onclick="javascript:menu_location('+"'ra"+ra_stsc+"'"+');">RA 평가자 지정이 완료되지 않았습니다. (평가 기한 이내에 평가자 지정을 완료해 주십시오.)</button></li>';
					   		add_html += '</ul>';   
					   		temp += rList[0].bas_ym + 'ra';
					   }else if(ra_stsc == '04' || ra_stsc == '13' || ra_stsc == '14' || ra_stsc == '15' || ra_stsc == '16' && !(document.cookie.includes(rList[0].bas_ym+"ra"))){ //부서팀장, orm, orm팀장, bcp, bcp팀장이 확인
					   		add_html += '<ul class="alarm-list">';
					   		add_html += '<li><button type="button" class="btn-alarm-list" title="바로가기" onclick="javascript:menu_location('+"'ra"+ra_stsc+"'"+');">RA 평가 결과 검토가 완료되지 않았습니다. (평가 기한 이내에 검토를 완료해 주세요.)</button></li>';
					   		add_html += '</ul>';
					   		temp += rList[0].bas_ym + 'ra';
					   }else if(ra_stsc == '04' || ra_stsc == '13' || ra_stsc == '14' || ra_stsc == '15' || ra_stsc == '16' && document.cookie.includes(rList[0].bas_ym+"ra")){
						    add_html += '<ul class="alarm-list2">';
					   		add_html += '<li><button type="button" class="btn-alarm-list" title="바로가기" onclick="javascript:menu_location('+"'ra"+ra_stsc+"'"+');">RA 평가 결과 검토가 완료되지 않았습니다. (평가 기한 이내에 검토를 완료해 주세요.)</button></li>';
					   		add_html += '</ul>';   
					   		temp += rList[0].bas_ym + 'ra';
					   }
					   
					   alarm_area.innerHTML = add_html;
					   document.cookie = temp;
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
	function menu_location(id){
		switch(id) {
			case "bia02": //BIA평가(평가자지정)
				parent.menuTrigger('0005102');
			break;
			case "bia04": //BIA평가(부서팀장)
				parent.menuTrigger('0008584');
			break;
			case "bia13": //BIA평가(orm담당자)
				parent.menuTrigger('0005103');
			break;
			case "bia14": //BIA평가(orm팀장)
				parent.menuTrigger('0008585');
			break;
			case "bia15": //BIA평가(bcp담당자)
				parent.menuTrigger('0008586');
			break;
			case "bia16": //BIA평가(bcp팀장)
				parent.menuTrigger('0008589');
			break;
			
		}
		
	}
	</script>
	<div class="page-header">
		<h1><span id="title"></span><!--  <small>실무자</small>--></h1>
		<ol class="breadcrumb">
			<li><img src="<%=System.getProperty("contextpath")%>/imgs/contents/breadcrumb_home.svg" class="ic" alt="Home Image"></li>
			<li id="path0"></li>
			<li id="path1"></li>
			<li id="sub_menu" class="active dropdown"></li>
		</ol>
		
		<div class="alarm-wrap">
			<button type="button" class="btn-alarm" title="미확인 알림 개수" onclick="openAlarm()">
				<div>
					<span id="alarm_cnt" class="cnt"></span>
				</div>
			</button>
		</div>
	</div>
	<!-- 미확인 알림 팝업 -->
	<article id="modalAlarm" class="popup modal">
		<div class="p_frame w600">	
			<div class="p_head">
				<h2 class="title">알림</h2>
			</div>
			<div class="p_body">						
				<div class="p_wrap">
					<div class="alarm-list-wrap" id="alarm_area" name="alarm_area">
						<!-- <ul class="alarm-list">
							<li>
								<button type="button" class="btn-alarm-list" title="바로가기" onclick="">RCSA 평가자 지정이 완료되지 않았습니다. (평가 기한 이내에 평가자 지정을 완료해 주십시오.)</button>
							</li>
							<li>
								<button type="button" class="btn-alarm-list" title="바로가기" onclick="">RCSA 평가자 수행이 완료되지 않았습니다. (평가 기한 이내에 해당 평가자 수행을 완료해 주십시오.)</button>
							</li>
							<li>
								<button type="button" class="btn-alarm-list" title="바로가기" onclick="">RCSA 평가 결과 검토가 완료되지 않았습니다. (평가 기한 내에 해당 평가 결과를 모두 완료해 주십시오.)</button>
							</li>
							<li>
								<button type="button" class="btn-alarm-list" title="바로가기" onclick="">대응방안 입력 필요 KRI 지표 발생 (7건)</button>
							</li>
						</ul> -->
					</div>
				</div>						
			</div>
			<button type="button" class="ico close fix btn-close" onclick="closeAlarm()"><span class="blind">닫기</span></button>	
		</div>
		<div class="dim p_close"></div>
	</article>
	
	<script>
		function openAlarm(){
			document.querySelector('#modalAlarm').classList.add('block');
			alarm();
		}
		function closeAlarm(){
			document.querySelector('#modalAlarm').classList.remove('block');
		}
	</script>
	<!-- 미확인 알림 팝업 //-->
	