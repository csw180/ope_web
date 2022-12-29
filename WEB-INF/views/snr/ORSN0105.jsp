<%--
/*---------------------------------------------------------------------------
 Program ID   : ORSN0105.jsp
 Program name : 시나리오 분석 보고서
 Description  : 
 Programer    : 고창호
 Date created : 2022.07.04
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
response.setHeader("Pragma", "No-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Expires", "0");

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
	<script src="<%=System.getProperty("contextpath")%>/js/jquery.fileDownload.js"></script>
	<title>시나리오 보고서</title>
	
	<script>
		$(document).ready(function(){
			parent.removeLoadingWs(); //부모창 프로그래스바 비활성화
			
		<%
			if(vLst.size()>0){
		%>
					<%-- $('#rskdrvr_anss_cntn').val('<%=(String)hMap.get("rskdrvr_anss_cntn")%>'); //위험요인분석내용
					$('#cft_plan_cntn').val('<%=(String)hMap.get("cft_plan_cntn")%>'); //대응방안내용
					$('#cfrc_opi_cntn').val('<%=(String)hMap.get("cfrc_opi_cntn")%>'); //협의의견내용 --%>
		<%
			}
		%>

			var param = JSON.parse(parent.ormsForm.jsonData.value); //바닥창에서 넘어온 파라미터 (json 변환후 사용)
			
			$("#sch_grp_org_c").val("<%=grp_org_c%>"); //그룹기관코드
			$("#sch_snro_sc").val(param.snro_sc); //평가회차
			$("#sch_bsn_prss_c").val(param.bsn_prss_c); //업무프로세스코드
			
			$("#snro_sc").html(param.snro_sc); //평가회차
			$("#lv1_bsn_prsnm").html(param.lv1_bsn_prsnm); //1LV업무프로세스
			$("#lv2_bsn_prsnm").html(param.lv2_bsn_prsnm); //2LV업무프로세스
			$("#lv3_bsn_prsnm").html(param.lv3_bsn_prsnm); //3LV업무프로세스
			$("#lv4_bsn_prsnm").html(param.lv4_bsn_prsnm); //4LV업무프로세스
			
			if(parent.$("#mode").val() == "R"){ //조회
				$('#').attr('readonly', true);
				$('#snro_set').attr('readonly', true);
				$('#cft_plan_cntn').attr('readonly', true);
				$('#cfrc_opi_cntn').attr('readonly', true);
				$("#btn_save").hide(); //저장버튼 숨김
			}
			
			// ibsheet 초기화
			initIBSheet();
			
		});
		
		/*Sheet 기본 설정 */
		function initIBSheet() {
			//시트 초기화
			mySheet.Reset(); // 손실
			mySheet2.Reset(); // KRI
			
			var initData = {};
			var initData3 = {};

			/*mySheet*/
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0,ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"search|init|resize"};
			
			var headers = [{Text:"No.|사건관리번호|사건관리부서|손실사건제목|일자|일자|손실금액|손실금액", Align:"Center"}
							,{Text:"No.|사건관리번호|사건관리부서|손실사건제목|발생일자|등록일자|총손실|순손실", Align:"Center"}];
			
			initData.Cols = [
				{Type:"Seq",Width:30,Align:"Center",SaveName:"SEQ",MinWidth:30,Edit:false},
				{Type:"int",Width:350,Align:"Center",SaveName:"lshp_amnno",MinWidth:100,Edit:false},
				{Type:"text",Width:350,Align:"Center",SaveName:"amn_brc",MinWidth:100,Edit:false},//사건관리부서
				{Type:"Text",Width:350,Align:"Center",SaveName:"lss_tinm",MinWidth:100,Edit:false},
				{Type:"Date",Width:120,Align:"Center",SaveName:"ocu_dt",MinWidth:100,Edit:false},
				{Type:"Date",Width:120,Align:"Center",SaveName:"reg_dt",MinWidth:100,Edit:false},
				{Type:"Int",Width:120,Align:"Center",SaveName:"ttls_am",MinWidth:100,Edit:false,Format:"#,##0"},
				{Type:"Int",Width:120,Align:"Center",SaveName:"guls_am",MinWidth:100,Edit:false,Format:"#,##0"},
				{Type:"Int",Width:150,Align:"Center",SaveName:"ttcn",MinWidth:100,Edit:false,Format:"#,##0",Hidden:true},
				{Type:"Int",Width:150,Align:"Center",SaveName:"lss_am_tt",MinWidth:100,Edit:false,Format:"#,##0",Hidden:true},
				{Type:"Int",Width:150,Align:"Center",SaveName:"lss_am_avg",MinWidth:100,Edit:false,Format:"#,##0",Hidden:true}
			];
			/*mySheet end*/
			
			/*mySheet2*/
			initData3.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0,ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"search|init|resize"};
			initData3.HeaderMode = {Sort:0};
			
			var headers3 = [{Text:"No.|KRI 명|KRI 월평균 값|KRI 발생 건수", Align:"Center"}];
			
			initData3.Cols = [
				{Type:"Seq",Width:30,Align:"Center",SaveName:"SEQ",MinWidth:30,Edit:false},
				{Type:"Text",Width:350,Align:"Center",SaveName:"oprk_rkinm",MinWidth:100,Edit:false},
				{Type:"Float",Width:120,Align:"Center",SaveName:"kri_mm_avl",MinWidth:100,Edit:false,Format:"#,###.000"},
				{Type:"Text",Width:120,Align:"Center",SaveName:"red_ocu_cn",MinWidth:100,Edit:false},
				{Type:"Int",Width:150,Align:"Center",SaveName:"ttcn",MinWidth:100,Edit:false,Format:"#,##0",Hidden:true},
				{Type:"Int",Width:150,Align:"Center",SaveName:"red_ocu_cn_tt",MinWidth:100,Edit:false,Format:"#,##0",Hidden:true}
			];
			/*mySheet2 end*/
			
			IBS_InitSheet(mySheet,initData);
			IBS_InitSheet(mySheet2,initData3);
			
			mySheet.InitHeaders(headers);
			mySheet.SetMergeSheet(eval("msHeaderOnly"));
			mySheet2.InitHeaders(headers3);
			
			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet.SetCountPosition(3);
			mySheet2.SetCountPosition(3);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			mySheet2.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			//컬럼의 너비 조정
			mySheet.FitColWidth();
			mySheet2.FitColWidth();
		
			doAction('search');
			
		}
		
		var row = "";
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
				case "search":  //데이터 조회
					var f = document.ormsForm;
					
					/*정상적인 방식으로 해당 팝업 호출시 아래 파라미터가 모두 존재해야함.*/
					if(f.sch_grp_org_c.value.trim()==''){ //그룹기관코드
						alert("그룹기관코드가 존재하지 않습니다. 관리자에게 문의하세요.");
						return;
					}
					
					if(f.sch_snro_sc.value.trim()==''){ //그룹기관코드
						alert("시나리오회차가 존재하지 않습니다. 관리자에게 문의하세요.");
						return;
					}
					
					if(f.sch_bsn_prss_c.value.trim()==''){ //그룹기관코드
						alert("업무프로세스코드가 존재하지 않습니다. 관리자에게 문의하세요.");
						return;
					}
					
					var opt = {};
				
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("snr");
					$("form[name=ormsForm] [name=process_id]").val("ORSN010502");
					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("snr");
					$("form[name=ormsForm] [name=process_id]").val("ORSN010504");
					
					mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					
					ORSN010503(); //RCSA
			
					break;
				case "help":	//신표준 측정값 산출가이드라인 팝업
					$("#winHelp").show();
					
					break;
				case "reload":  //조회데이터 리로드
				
					mySheet.RemoveAll();
					initIBSheet();
					break;
				case "down2excel":
					setExcelFileName("손실사건 내역");
					setExcelDownCols("0|1|2|3");
					mySheet.Down2Excel(excel_params);
	
					break;
			}
		}
		
		// 손실
		function mySheet_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				if(mySheet.GetDataFirstRow() > 0){
					
					$("#ttcn").html(setComma(mySheet.GetCellValue(2,"ttcn"))); //발생 건수 합계
					$("#lss_am_tt").html(setComma(mySheet.GetCellValue(2,"lss_am_tt"))); //손실 금액 합계
					$("#lss_am_avg").html(setComma(mySheet.GetCellValue(2,"lss_am_avg"))); //손실 금액 평균
				}
				
			}
			
			//컬럼의 너비 조정
			mySheet.FitColWidth();
		}
		
		//RCSA - 1.리스크평가일정조회(ORSN010503)
		function ORSN010503(){
			var f = document.ormsForm;
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "snr");
			WP.setParameter("process_id", "ORSN010503");
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();

			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
			    {
				  success: function(result){
					  if(result != 'undefined' && result.rtnCode== '0'){
						var rList = result.DATA;
					    var html="";
					    if(rList.length > 0){
							for (var i=0; i<rList.length; i++ ){
								$('#bas_ym_'+(i+1)).val(rList[i].bas_ym); //리스크평가일정
							}
							
							ORSN010506(); //위험평가목록조회
					    }
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
		
		function rk_evl_grd_avl(s){
		
			if(s=='4'){return 'R'}
			else if(s=='3'){return  'Y'}
			else if(s=='2'){return  'G'}
			else if(s=='1'){return  'W'}
			else if(s=='' ){return ''}			
	
		}
		
		function ctev_grd_avl(s){
			
			if(s='1'){return '상'}
			else if(s='2'){return  '중'}
			else if(s='3'){return  '하'}		
		
		}
		
		
		
		//RCSA - 2.위험평가목록조회(ORSN010506)
		var html = "";
		var ra_ttcn = 0; //위험평가  RED 발생 건수
		var ctev_ttcn = 0; //통제평가 RED 발생 건수
		function ORSN010506(){
			var f = document.ormsForm;
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "snr");
			WP.setParameter("process_id", "ORSN010506");
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();

			showLoadingWs(); // 프로그래스바 활성화
			//sync_load : 비동기호출
			WP.sync_load(url, inputData,
			    {
				  success: function(result){
					  if(result != 'undefined' && result.rtnCode== '0'){
						  
						var rList = result.DATA;
						
					    if(rList.length > 0){
							html += '<table>';
							html += '	<tbody class="center">';
							html += '		<colgroup>';
							html += '			<col style="width: 70px;">';
							html += '			<col>';
							
							for(var i=0; i<9; i++){
								if($('#bas_ym_'+(i+1)).val() != ""){
									html += '			<col style="width: 60px;">';
								}
							}
							
							html += '		</colgroup>';
							html += '		<tr>';
							html += '			<th><center>평가내용</center></th>';
							html += '			<th><center>내용</center></th>';
							
							for(var i=0; i<9; i++){
								if($('#bas_ym_'+(i+1)).val() != ""){
									html += '			<th><center>'+$('#bas_ym_'+(i+1)).val()+'</center></th>'; //리스크평가일정조회
								}
							}
							html += '		</tr>';
							
							for (var i=0; i<rList.length; i++){

									
								html += '		<tr>';
								html += '			<td><span id=""><center>위험</center></span></td>';
								html += '			<td><span id="">'+rList[i].rk_isc_cntn+'</span></td>'; //리스크사례내용
								
								if($('#bas_ym_1').val() != "") html += '			<td><span id="" class="fr">'+rk_evl_grd_avl(rList[i].rk_evl_grd_avl_1)+'</span></td>'; //평균1
								if($('#bas_ym_2').val() != "") html += '			<td><span id="" class="fr">'+rk_evl_grd_avl(rList[i].rk_evl_grd_avl_2)+'</span></td>'; //평균2
								if($('#bas_ym_3').val() != "") html += '			<td><span id="" class="fr">'+rk_evl_grd_avl(rList[i].rk_evl_grd_avl_3)+'</span></td>'; //평균3
								if($('#bas_ym_4').val() != "") html += '			<td><span id="" class="fr">'+rk_evl_grd_avl(rList[i].rk_evl_grd_avl_4)+'</span></td>'; //평균4
								if($('#bas_ym_5').val() != "") html += '			<td><span id="" class="fr">'+rk_evl_grd_avl(rList[i].rk_evl_grd_avl_5)+'</span></td>'; //평균5
								if($('#bas_ym_6').val() != "") html += '			<td><span id="" class="fr">'+rk_evl_grd_avl(rList[i].rk_evl_grd_avl_6)+'</span></td>'; //평균6
								if($('#bas_ym_7').val() != "") html += '			<td><span id="" class="fr">'+rk_evl_grd_avl(rList[i].rk_evl_grd_avl_7)+'</span></td>'; //평균7
								if($('#bas_ym_8').val() != "") html += '			<td><span id="" class="fr">'+rk_evl_grd_avl(rList[i].rk_evl_grd_avl_8)+'</span></td>'; //평균8
								if($('#bas_ym_9').val() != "") html += '			<td><span id="" class="fr">'+rk_evl_grd_avl(rList[i].rk_evl_grd_avl_9)+'</span></td>'; //평균9
								
								html += '		</tr>';
								
								/*위험평가 적색발생 전체건수*/
								ra_ttcn += Number(rList[i].red_cn_1.replace("",0))
								        + Number(rList[i].red_cn_2.replace("",0))
								        + Number(rList[i].red_cn_3.replace("",0))
								        + Number(rList[i].red_cn_4.replace("",0))
								        + Number(rList[i].red_cn_5.replace("",0))
								        + Number(rList[i].red_cn_6.replace("",0))
								        + Number(rList[i].red_cn_7.replace("",0))
								        + Number(rList[i].red_cn_8.replace("",0))
								        + Number(rList[i].red_cn_9.replace("",0));
								
								$('#sch_oprk_rkp_id').val(rList[i].oprk_rkp_id); //운영리스크리스크풀ID
								ORSN010507(); //통제평가목록조회
							}
							html += '	</tbody>';
							html += '</table> ';
							
							$("#ra_ttcn").html(setComma(ra_ttcn)); //위험평가 RED 발생 건수
							$("#ctev_ttcn").html(setComma(ctev_ttcn)); //통제평가 RED 발생 건수
							$("#divTest").html(html);
					    }
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
		
		//RCSA - 3.통제평가목록조회(ORSN010507)
		function ORSN010507(){
			var f = document.ormsForm;
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "snr");
			WP.setParameter("process_id", "ORSN010507");
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();

			showLoadingWs(); // 프로그래스바 활성화
			//sync_load : 비동기호출
			WP.sync_load(url, inputData,
			    {
				 success: function(result){
					  if(result != 'undefined' && result.rtnCode== '0'){
						  
						var rList = result.DATA;
						
					    if(rList.length > 0){
					    	
					    		
							html += '<table>';
							html += '	<tbody class="center">';
							html += '		<colgroup>';
							html += '			<col style="width: 70px;">';
							html += '			<col>';
							
							for(var i=0; i<9; i++){
								if($('#bas_ym_'+(i+1)).val() != ""){
									html += '			<col style="width: 60px;">';
								}
							}
							
							html += '		</colgroup>';
							html += '		<tr>';
							
							html += '			<th><center>평가내용</center></th>';
							html += '			<th><center>내용</center></th>';
							
							for(var i=0; i<9; i++){
								if($('#bas_ym_'+(i+1)).val() != ""){
									html += '			<th><center>'+$('#bas_ym_'+(i+1)).val()+'</center></th>'; //리스크평가일정조회
								}
							}
							html += '		</tr>';
							
							for (var i=0; i<rList.length; i++){
								html += '		<tr>';
								html += '			<td><span id=""><center>통제</center></span></td>';
								html += '			<td><span id="">'+rList[i].ctl_cntn+'</span></td>'; //통제내용
								
								if($('#bas_ym_1').val() != "") html += '			<td><span id="" class="fr">'+ctev_grd_avl(rList[i].ctev_grd_avl_1)+'</span></td>'; //평균1
								if($('#bas_ym_2').val() != "") html += '			<td><span id="" class="fr">'+ctev_grd_avl(rList[i].ctev_grd_avl_2)+'</span></td>'; //평균2
								if($('#bas_ym_3').val() != "") html += '			<td><span id="" class="fr">'+ctev_grd_avl(rList[i].ctev_grd_avl_3)+'</span></td>'; //평균3
								if($('#bas_ym_4').val() != "") html += '			<td><span id="" class="fr">'+ctev_grd_avl(rList[i].ctev_grd_avl_4)+'</span></td>'; //평균4
								if($('#bas_ym_5').val() != "") html += '			<td><span id="" class="fr">'+ctev_grd_avl(rList[i].ctev_grd_avl_5)+'</span></td>'; //평균5
								if($('#bas_ym_6').val() != "") html += '			<td><span id="" class="fr">'+ctev_grd_avl(rList[i].ctev_grd_avl_6)+'</span></td>'; //평균6
								if($('#bas_ym_7').val() != "") html += '			<td><span id="" class="fr">'+ctev_grd_avl(rList[i].ctev_grd_avl_7)+'</span></td>'; //평균7
								if($('#bas_ym_8').val() != "") html += '			<td><span id="" class="fr">'+ctev_grd_avl(rList[i].ctev_grd_avl_8)+'</span></td>'; //평균8
								if($('#bas_ym_9').val() != "") html += '			<td><span id="" class="fr">'+ctev_grd_avl(rList[i].ctev_grd_avl_9)+'</span></td>'; //평균9
								
								html += '		</tr>';
								
								/*통제평가 적색발생 전체건수*/
								ctev_ttcn += Number(rList[i].red_cn_1.replace("",0))
								          + Number(rList[i].red_cn_2.replace("",0))
								          + Number(rList[i].red_cn_3.replace("",0))
								          + Number(rList[i].red_cn_4.replace("",0))
								          + Number(rList[i].red_cn_5.replace("",0))
								          + Number(rList[i].red_cn_6.replace("",0))
								          + Number(rList[i].red_cn_7.replace("",0))
								          + Number(rList[i].red_cn_8.replace("",0))
								          + Number(rList[i].red_cn_9.replace("",0));
							}
					    }
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
		
		// KRI
		function mySheet2_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				if(mySheet2.GetDataFirstRow() > 0){
					$("#kri_ttcn").html(setComma(mySheet2.GetCellValue(1,"ttcn"))); //업무프로세스 관련 KRI 개수
					$("#red_ocu_cn_tt").html(setComma(mySheet2.GetCellValue(1,"red_ocu_cn_tt"))); //RED 발생 건수 합계
				}
				
			}
			
			//컬럼의 너비 조정
			mySheet.FitColWidth();
		}
		
		function save(){
			var f = document.ormsForm;
			
			/* for(var i=0; i<arrow.length; i++){
				if(mySheet.GetCellValue(arrow[i], "snro_dcz_stsc") == "03"){ //게시완료인 경우
					alert("이미 결재가 완료된 건입니다. .["+(arrow[i]-1)+"]");
					return; */
			
			/*정상적인 방식으로 해당 팝업 호출시 아래 파라미터가 모두 존재해야함.*/
			if(f.sch_grp_org_c.value.trim()==''){ //그룹기관코드
				alert("그룹기관코드가 존재하지 않습니다. 관리자에게 문의하세요.");
				return;
			}
			
			if(f.sch_snro_sc.value.trim()==''){ //그룹기관코드
				alert("시나리오회차가 존재하지 않습니다. 관리자에게 문의하세요.");
				return;
			}
			
			if(f.sch_bsn_prss_c.value.trim()==''){ //그룹기관코드
				alert("업무프로세스코드가 존재하지 않습니다. 관리자에게 문의하세요.");
				return;
			}
			
			// 위험요인분석내용
			if(f.rskdrvr_anss_cntn.value.trim()==''){
				alert("위험요인 분석을 입력하십시오.");
				f.rskdrvr_anss_cntn.focus();
				return;
			}
			// 시나리오 설정
			if(f.snro_set.value.trim()==''){
				alert("시나리오 설정을 입력하십시오.");
				f.snro_set.focus();
				return;
			}
			
			// 대응방안내용
			if(f.cft_plan_cntn.value.trim()==''){
				alert("대응방안을 입력하십시오.");
				f.cft_plan_cntn.focus();
				return;
			}
			
			// 협의의견내용
			if(f.cfrc_opi_cntn.value.trim()==''){
				alert("리스크관리 협의회 의견을 입력하십시오.");
				f.cfrc_opi_cntn.focus();
				return;
			}
			
			
			// 위험요인분석내용 50자 이상
			if(f.rskdrvr_anss_cntn.value.trim().replace(/ /g,"").length < 50){
				alert("위험요인 분석을 50자 이상 입력하십시오.");
				f.rskdrvr_anss_cntn.focus();
				return;
			}
			
			// 시나리오설정 50자 이상
			if(f.snro_set.value.trim().replace(/ /g,"").length < 50){
				alert("시나리오 설정을 50자 이상 입력하십시오.");
				f.snro_set.focus();
				return;
			}
			
			// 대응방안내용 50자 이상
			if(f.cft_plan_cntn.value.trim().replace(/ /g,"").length < 50){
				alert("대응방안을 50자 이상 입력하십시오.");
				f.cft_plan_cntn.focus();
				return;
			}
			
			// 협의의견내용 50자 이상
			if(f.cfrc_opi_cntn.value.trim().replace(/ /g,"").length < 50){
				alert("리스크관리 협의회 의견을 50자 이상 입력하십시오.");
				f.cfrc_opi_cntn.focus();
				return;
			}
			
			if(!confirm("저장하시겠습니까?")) return;
			
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "snr");
			WP.setParameter("process_id", "ORSN010505");
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
				{
					success: function(result){
						if(result!='undefined' && result.rtnCode=="S") {
							alert("저장 하였습니다.");
							parent.doAction("search"); //부모창 재조회
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
		
		/*배열 중복제거*/
		function unique(paramArr){
			var returnArr = new Array();
			var chk = true;
			
			for(var i=0; i<paramArr.length; i++){
				//중복유무 초기화
				chk = true;
				
				//중복체크
				//값을 담은 배열을 전체 반복하면서 담을 데이터와 담겨진 데이터를 비교
				for(value in returnArr){
					//중복유무를 체크하여 값을 담을지 말지 결정
					if(returnArr[value] == paramArr[i]){
						chk = false;
					}
				}
				
				if(chk){
					returnArr.push(paramArr[i]);
				}
			}
			
			return returnArr; 
		}
		
		function fn_print(){
			$('#poi_bsn_prsnm').val($('#lv1_bsn_prsnm').text()+" > "+$('#lv2_bsn_prsnm').text()+" > "+$('#lv3_bsn_prsnm').text()+" > "+$('#lv4_bsn_prsnm').text());
			$('#poi_ttcn').val($('#ttcn').text());
			$('#poi_lss_am_tt').val($('#lss_am_tt').text());
			$('#poi_lss_am_avg').val($('#lss_am_avg').text());
			$('#poi_ra_ttcn').val($('#ra_ttcn').text());
			$('#poi_ctev_ttcn').val($('#ctev_ttcn').text());
			$('#poi_lshp_amnno').val($('#lshp_amnno').text());
			$('#poi_amn_brc').val($('#amn_brc').text());
			$('#poi_lss_tinm').val($('#lss_tinm').text());
			$('#poi_ocu_dt').val($('#ctev_ttcn').text());
			$('#poi_reg_dt').val($('#reg_dt').text());
			$('#poi_ttls_am').val($('#ttls_am').text());
			$('#poi_guls_am').val($('#guls_am').text());
			$('#poi_kri_ttcn').val($('#kri_ttcn').text());
			$('#poi_red_ocu_cn_tt').val($('#red_ocu_cn_tt').text());
			
			var f = document.ormsForm;
			
			showLoadingWs(); // 프로그래스바 활성화
			$.fileDownload("<%=System.getProperty("contextpath")%>/snrReportExcel.do", {
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
	<article class="popup modal block">
		<div class="p_frame w1100">

			<div class="p_head">
				<h1 class="title">시나리오 보고서</h1>
			</div>


			<div class="p_body">
				
				<div class="p_wrap">
					<form id="ormsForm" name="ormsForm">
					<input type="hidden" id="path" name="path" />
					<input type="hidden" id="process_id" name="process_id" />
					<input type="hidden" id="commkind" name="commkind" />
					<input type="hidden" id="method" name="method" />
					
					<input type="hidden" id="sch_grp_org_c" name="sch_grp_org_c" /> <!-- 그룹기관코드 -->
					<input type="hidden" id="sch_snro_sc" name="sch_snro_sc" /> <!-- 시나리오회차 -->
					<input type="hidden" id="sch_bsn_prss_c" name="sch_bsn_prss_c" /> <!-- 업무프로세스코드 -->
					
					<input type="hidden" id="sch_oprk_rkp_id" name="sch_oprk_rkp_id" /> <!-- 운영리스크리스크풀ID(통제평가목록조회 사용) -->
					
					<input type="hidden" id="bas_ym_1" name="bas_ym_1" /> <!-- 리스크평가일정 -->
					<input type="hidden" id="bas_ym_2" name="bas_ym_2" /> <!-- 9개 TEMP (보통 분기별로 하지만 4개이상 가능하여 임시로 9개 설정함) -->
					<input type="hidden" id="bas_ym_3" name="bas_ym_3" />
					<input type="hidden" id="bas_ym_4" name="bas_ym_4" />
					<input type="hidden" id="bas_ym_5" name="bas_ym_5" />
					<input type="hidden" id="bas_ym_6" name="bas_ym_6" />
					<input type="hidden" id="bas_ym_7" name="bas_ym_7" />
					<input type="hidden" id="bas_ym_8" name="bas_ym_8" />
					<input type="hidden" id="bas_ym_9" name="bas_ym_9" />
					
					<!-- PRINT 사용 -->
					<input type="hidden" id="poi_bsn_prsnm" name="poi_bsn_prsnm" />
					<input type="hidden" id="poi_ttcn" name="poi_ttcn" />
					<input type="hidden" id="poi_lss_am_tt" name="poi_lss_am_tt" />
					<input type="hidden" id="poi_lss_am_avg" name="poi_lss_am_avg" />
					<input type="hidden" id="poi_ra_ttcn" name="poi_ra_ttcn" />
					<input type="hidden" id="poi_ctev_ttcn" name="poi_ctev_ttcn" />
					
					<input type="hidden" id="poi_lshp_amnno" name="poi_lshp_amnno" />
					<input type="hidden" id="poi_amn_brc" name="poi_amn_brc" />
					<input type="hidden" id="poi_lss_tinm" name="poi_lss_tinm" />
					<input type="hidden" id="poi_ocu_dt" name="poi_ocu_dt" />
					<input type="hidden" id="poi_reg_dt" name="poi_reg_dt" />
					<input type="hidden" id="poi_ttls_am" name="poi_ttls_am" />
					<input type="hidden" id="poi_guls_am" name="poi_guls_am" />
					
	
					<input type="hidden" id="poi_kri_ttcn" name="poi_kri_ttcn" />
					<input type="hidden" id="poi_red_ocu_cn_tt" name="poi_red_ocu_cn_tt" />
					
					
					<section class="box box-grid">						
						<div class="wrap-table">
							<table>
								<colgroup>
									<col style="width: 150px;">
									<col style="width: 150px;">
									<col style="width: 150px;">
									<col>
								</colgroup>
								<tr>
									<th>평가회차</th>
									<td><span id="snro_sc"></span></td>
									<th>업무프로세스</th>
									<td>
										<ol class="dep-list">
											<li id="lv1_bsn_prsnm"></li>
											<li id="lv2_bsn_prsnm"></li>
											<li id="lv3_bsn_prsnm"></li>
											<li id="lv4_bsn_prsnm"></li>
										</ol>
									</td>
								</tr>
							</table>
						</div>
					</section>

					<section class="box box-grid">
						<div class="box-header">
							<h2 class="box-title">최근 1년 손실사건 내역</h2>
						</div>
						<div class="wrap-table">
							<table>
								<tbody class="center">
									<tr>
										<th>발생 건수 합계</th>
										<th>손실 금액 합계</th>
										<th>손실 금액 평균</th>
									</tr>
									<tr>
										<td><span id="ttcn">-</span></td>
										<td><span id="lss_am_tt">-</span></td>
										<td><span id="lss_am_avg">-</span></td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="wrap-grid h200">
							<script> createIBSheet("mySheet", "100%", "100%"); </script>
						</div>
					</section>

					<section class="box box-grid">
						<div class="box-header">
							<h2 class="box-title">RCSA 평가 결과</h2>
						</div>
						<div class="wrap-table">
							<table>
								<tbody class="center">
									<tr>
										<th>위험평가 RED 발생 건수</th>
										<th>통제평가 RED 발생 건수</th>
									</tr>
									<tr>
										<td><span id="ra_ttcn">-</span></td>
										<td><span id="ctev_ttcn">-</span></td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="wrap-table" id="divTest">
							<!-- <table>
								<tbody class="center">
									<colgroup>
										<col>
										<col style="width: 65%;">
										<col>
										<col>
										<col>
										<col>
									</colgroup>
									<tr>
										<th>평가구분</th>
										<th>내용</th>
										<th>202101</th>
										<th>202102</th>
										<th>202103</th>
										<th>202104</th>
									</tr>
									<tr>
										<td><span id="">위험</span></td>
										<td><span id="">유선으로 고객 의사 확인 후 ...</span></td>
										<td><span id="" class="fr">1</span></td>
										<td><span id="" class="fr">2</span></td>
										<td><span id="" class="fr">3</span></td>
										<td><span id="" class="fr">4</span></td>
									</tr>
								</tbody>
							</table> -->
						</div>
					</section>

					<section class="box box-grid">
						<div class="box-header">
							<h2 class="box-title">최근 1년 KRI RED 발생 내역(전사 기준)</h2>
						</div>
						<div class="wrap-table">
							<table>
								<tbody class="center">
									<tr>
										<th>업무프로세스 관련 KRI 개수</th>
										<th>RED 발생 건수 합계</th>
									</tr>
									<tr>
										<td><span id="kri_ttcn">-</span></td>
										<td><span id="red_ocu_cn_tt">-</span></td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="wrap-grid h200">
							<script> createIBSheet("mySheet2", "100%", "100%"); </script>
						</div>
					</section>

					<section class="box box-grid">
						<div class="wrap-table">
							<table>
								<colgroup>
									<col style="width: 180px;">
									<col>
								</colgroup>
								<tr>
									<th>위험요인 분석</th>
									<td>
										<textarea name="rskdrvr_anss_cntn" id="rskdrvr_anss_cntn" class="form-control h80" maxlength="660"><%=StringUtil.replaceAll((String)hMap.get("rskdrvr_anss_cntn"),"\r\n","</br>")%></textarea>
									</td>
								</tr>
								<tr>
									<th>시나리오 설정</th>
									<td>
										<textarea name="snro_set" id="snro_set" class="form-control h80" maxlength="660"><%=StringUtil.replaceAll((String)hMap.get("snro_set"),"\r\n","</br>")%></textarea>
									</td>
								</tr> 
								<tr>
									<th>대응방안</th>
									<td>
										<textarea name="cft_plan_cntn" id="cft_plan_cntn" class="form-control h80" maxlength="660"><%=StringUtil.replaceAll((String)hMap.get("cft_plan_cntn"),"\r\n","</br>")%></textarea>
									</td>
								</tr>
								<tr>
									<th>리스크관리 협의회 의견</th>
									<td>
										<textarea name="cfrc_opi_cntn" id="cfrc_opi_cntn" class="form-control h80" maxlength="1330"><%=StringUtil.replaceAll((String)hMap.get("cfrc_opi_cntn"),"\r\n","</br>")%></textarea>
									</td>
								</tr>
							</table>
						</div>
					</section>
					
					</form>
				</div>
				
			</div>

			<div class="p_foot">
				<div class="btn-wrap">
					<button type="button" class="btn btn-primary" id="btn_save" onclick="save();">저장</button>
					<button type="button" class="btn btn-default btn-close">닫기</button>
				</div>
			</div>

			<button type="button" class="btn btn-xs btn-default btn-fix" type="button" onclick="fn_print();"><i class="fa fa-print"></i><span class="txt">PRINT</span></button>
			<button class="ico close fix btn-close"><span class="blind">닫기</span></button>

		</div>
		<div class="dim p_close"></div>
	</article>
	
	<%@ include file="../comm/PrssInfP.jsp" %> <!-- 업무프로세스 공통 팝업 -->
	
	<script>
		$(document).ready(function(){
			//열기
			$(".btn-open").click( function(){
				$(".popup").show();
			});
			//닫기
			$(".btn-close").click( function(event){
				$(".popup",parent.document).hide();
				parent.$("#ifrORSN0105").attr("src","about:blank");
				event.preventDefault();
			});
		});
			
		function closePop(){
			$("#winNewAccAdd",parent.document).hide();
		}

	</script>
</body>

</html>