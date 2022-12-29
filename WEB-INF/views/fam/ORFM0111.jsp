<%--
/*---------------------------------------------------------------------------
 Program ID   : ORFM0111.jsp
 Program name : 평판자본량 산출 및 조회
 Description  : 
 Programmer   : 김병현
 Date created : 2022.05.31
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ page import="com.shbank.orms.comm.SysDateDao"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();



DynaForm form = (DynaForm)request.getAttribute("form");

String rep_menu_dsc = (String)form.get("rep_menu_dsc");
System.out.println(rep_menu_dsc);
%>
<!DOCTYPE html>
<html lang="ko">
	<head>
	    <%@ include file="../comm/library.jsp" %>
		<title>평판자본량 산출 및 조회</title>
		<script>
			$(document).ready(function(){
				monthChange();
				// ibsheet 초기화
				initIBSheet();
			});
			
			/*Sheet 기본 설정 */
			function initIBSheet() {
				//시트 초기화
				mySheet.Reset();
			var initData = {};
			initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
			initData.Cols = [
				{Header:"선택|선택",										Type:"CheckBox",Width:60,Align:"Center",SaveName:"ischeck",Wrap:1,MinWidth:60},
				{Header:"기준년월|기준년월",									Type:"Text",Width:80,Align:"Center",SaveName:"bas_ym",Wrap:1,MinWidth:60,Edit:0},
				{Header:"평판 지수 (Index) 결과|당분기",						Type:"Text",Width:100,Align:"Center",SaveName:"rep_idx",Wrap:1,MinWidth:60,Edit:0},
				{Header:"평판 지수 (Index) 결과|전분기",						Type:"Text",Width:100,Align:"Center",SaveName:"bef_rep_idx",Wrap:1,MinWidth:60,Edit:0},
				{Header:"증감률(%)|증감률(%)",								Type:"Float",Width:100,Align:"Center",SaveName:"idx_rate",Wrap:1,MinWidth:60,Edit:0,Format:"##0.##"},
				{Header:"평판리스크\n내부자본량(억원)|평판리스크\n내부자본량(억원)",	Type:"Float",Width:150,Align:"Right",SaveName:"rep_m",Wrap:1,MinWidth:60,Edit:0},
				{Header:"결재 상태|결재 상태",								Type:"Text",Width:100,Align:"Center",SaveName:"inp",Wrap:1,MinWidth:60,Edit:0},
				{Header:"반려 내용|반려 내용",								Type:"Text",Width:300,Align:"Left",SaveName:"rtn_cntn",Wrap:1,MinWidth:60,Edit:0},
				{Header:"세부정보 \n입력 및 조회|세부정보 \n입력 및 조회",			Type:"Button",Width:100,Align:"Center",SaveName:"DetailDcz",Wrap:1,MinWidth:60,Edit:0},
				{Header:"상태코드",										Type:"Text",Width:80,Align:"Center",SaveName:"idvdc_val",Wrap:1,MinWidth:10,Edit:0, Hidden:true}
			];/*mySheet end*/
				
				IBS_InitSheet(mySheet,initData);
				//필터표시
				//mySheet.ShowFilterRow();  
				
				//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
				//mySheet.SetCountPosition(3);
				
				mySheet.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
				// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
				// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				mySheet.SetSelectionMode(4);
				
				//마우스 우측 버튼 메뉴 설정
				//setRMouseMenu(mySheet);
				
				doAction('search');
			}
			
			var row = "";
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			
			//시트 ContextMenu선택에 대한 이벤트
			function mySheet_OnSelectMenu(text,code){
				alert('onselectmenu!');
				if(text=="엑셀다운로드"){
					doAction("down2excel");	
				}else if(text=="엑셀업로드"){
					doAction("loadexcel");
				}
			}
			
			function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
				//alert('ondbclick!');
				if(Row >= mySheet.GetDataFirstRow()){
					$("#bas_ym").val(mySheet.GetCellValue(Row,"bas_ym"));
					doAction("mod");
				}
			}
			function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
				//alert('onclick!');
				if(mySheet.ColSaveName(Col) == "btn"  && mySheet.GetCellValue(Row,"btn") != ""){
					if(Row >= mySheet.GetDataFirstRow()){
						$("#bas_ym").val(mySheet.GetCellValue(Row,"bas_ym"));
						doAction("mod");
					}
				}
			}
			
			function mySheet_OnRowSearchEnd(Row) {
				mySheet.SetCellText(Row,"DetailDcz",'<button class="btn btn-xs btn-default" type="button" onclick="DczStatus(\''+mySheet.GetCellValue(Row,"bas_ym")+'\')"> <span class="txt">상세</span><i class="fa fa-caret-right ml5"></i></button>')
			}
			function DczStatus(bas_ym) {
				$("#rpst_id").val(bas_ym);
				$("#bas_pd").val(bas_ym);
				schDczPopup(3);
			}
		
			/*Sheet 각종 처리*/
			function doAction(sAction) {
				switch(sAction) {
					case "search":  //데이터 조회
						var opt = {};
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("fam");
						$("form[name=ormsForm] [name=process_id]").val("ORFM011102");
						mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
						break;
					case "reload":  //조회데이터 리로드
						mySheet.RemoveAll();
						initIBSheet();
						break;
					case "down2excel":
						setExcelFileName("영업지수 잔액 정보");
						setExcelDownCols("0|1|2|3|4");
						mySheet.Down2Excel(excel_params);
						break;
					case "del":      //삭제
						del_fam();
						break;	
					case "mod":
						if($("#rki_id").val() == ""){
							alert("선택해주세요.");
							return;
						}else{
							$("#ifrFamMod").attr("src","about:blank");
							$("#winFamMod").show();
							setTimeout(modFam,1);
						}
						break; 
					case "mod1":
						$("#ifrFamMod1").attr("src","about:blank");
						$("#winFamMod1").show();
						showLoadingWs(); // 프로그래스바 활성화
						setTimeout(modFam1,1);
						//modRisk();
						break; 
					case "sub":  //리스크담당자 상신 (03-> 04)
						if(InputCheck(sAction) == false) return;
					    $("#dcz_objr_emp_auth").val("'004','006'");
					    schDczPopup(1);
						break;
					
					case "dcz":  //결제
						if(InputCheck(sAction) == false) return;
						$("#dcz_objr_emp_auth").val("'002'");
						schDczPopup(2);
						//doSave();
						break;
						
					case "ret":  //반려
						if(InputCheck(sAction) == false) return;
						$("#dcz_rmk_c").val("01");
						schDczPopup(2);
						doSave();
						break;
				}
			}
			
			//입력값 체크
			function InputCheck(sAction) {
				$("#rpst_id").val("");
				var rep_menu_dsc = <%=rep_menu_dsc%>; 
				var ret_yn ="N";
				if(sAction=="ret")
					{
					 ret_yn = "Y";
					}
			     var ckcnt = "";
				  
				 for(var i = mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
						if(mySheet.GetCellValue(i, "ischeck")=="1"){				
							ckcnt++;
						}
					} 
			     if(ckcnt==0){
			     	alert("결재대상을 선택해 주세요.");
			     	return false;
			     }		
			     
				 for(var i=mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
					 if( mySheet.GetCellValue(i,"ischeck") == "1" ){
						  if($("#rpst_id").val()==""){
							  	$("#rpst_id").val(mySheet.GetCellValue(i,"bas_ym"));
							  	$("#bas_pd").val(mySheet.GetCellValue(i,"bas_ym"));
					  }
					  if( rep_menu_dsc == 1){
							 if( mySheet.GetCellValue(i,"idvdc_val") == "13" ){
								 alert("이미 상신 된 건 입니다. \n[리스크 프로파일 : "+mySheet.GetCellValue(i,"rk_isc_cntn")+"]");
								 return false;
							 }else if(mySheet.GetCellValue(i,"idvdc_val") == "14" ){
								 alert("이미 최종결재가 완료되었습니다.");
								 return false;
							 }
						}
					  else if( rep_menu_dsc == 2){
						  if( mySheet.GetCellValue(i,"idvdc_val") == "01" ){
								 alert("상신되지 않은 건 입니다.");
								 return false;
							 }else if(mySheet.GetCellValue(i,"idvdc_val") == "14" ){
								 alert("이미 최종결재가 완료되었습니다.");
								 return false;
							 }
					 	}	
				 	}
				}
				return true;
			}
			
			function mySheet_OnSearchEnd(code, message) {
	
				if(code != 0) {
					alert("조회 중에 오류가 발생하였습니다..");
				}else{
					for(var i = mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
						if(mySheet.GetCellValue(i, "idvdc_val")=="01"){
							mySheet.SetCellFontColor(i, "inp", "#FF0000");
							//mySheet.SetCellBackColor(i, "bsn_prsnm", "#E2E2E2");
								<%-- <%if(rep_menu_dsc.equals("1")) { %>
									mySheet.SetCellEditable(i,"ischeck",1);
								<%}else if(rep_menu_dsc.equals("2")) { %>
									mySheet.SetCellEditable(i,"ischeck",0);
								<%} %> --%>
							}else if(mySheet.GetCellValue(i, "idvdc_val")=="13"){
								<%-- <%if(rep_menu_dsc.equals("1")) { %>
									mySheet.SetCellEditable(i,"ischeck",0);
								<%}else if(rep_menu_dsc.equals("2")) { %>
									mySheet.SetCellEditable(i,"ischeck",1);
								<%} %> --%>
							}else if(mySheet.GetCellValue(i, "idvdc_val")=="14"){
								<%-- <%if(rep_menu_dsc.equals("1")) { %>
									mySheet.SetCellEditable(i,"ischeck",0);
								<%}else if(rep_menu_dsc.equals("2")) { %>
									mySheet.SetCellEditable(i,"ischeck",0);
								<%} %> --%>
							}
					}
				}
				
				//컬럼의 너비 조정
				mySheet.FitColWidth();
			}
			function modFam(){ //평판지표상세팝업(더블클릭)
				var f = document.ormsForm;
				f.method.value="Main";
		        f.commkind.value="fam";
		        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
		        f.process_id.value="ORFM011201";
				f.target = "ifrFamMod";
				f.submit();
			}
			function modFam1(){ //신규등록팝업
				var f = document.ormsForm;
				f.method.value="Main";
		        f.commkind.value="fam";
		        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
		        f.process_id.value="ORFM011301";
				f.target = "ifrFamMod1";
				f.submit();
			}
			function del_fam(){
				var f = document.ormsForm;
				var add_html = "";
				if(mySheet.GetDataFirstRow()>=0){
					for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
						if(mySheet.GetCellValue(j,"ischeck")==1){
							add_html += "<input type='hidden' name='sch_bas_ym' value='" + mySheet.GetCellValue(j,"bas_ym") + "'>";
						}
					}
				}
				if(add_html==""){
					alert("삭제할 평판지표를 선택하세요.");
					return;
				}

	            tmp_area.innerHTML = add_html;
				
				
				var f = document.ormsForm;
				if(!confirm("선택한 평판자본량을 삭제 하시겠습니까?")) return;
					
				WP.clearParameters();
				WP.setParameter("method", "Main");
				WP.setParameter("commkind", "fam");
				WP.setParameter("process_id", "ORFM011103");  //ORFM010103
				WP.setForm(f);
				
				var url = "<%=System.getProperty("contextpath")%>/comMain.do";
				var inputData = WP.getParams();
				
				//alert(inputData);
				
				showLoadingWs(); // 프로그래스바 활성화
				WP.load(url, inputData,
				    {
					  success: function(result){
						  if(result != 'undefined' && result.rtnCode== 'S'){
							  alert(result.rtnMsg);
							  doAction('search');
						  }
						  
					  },
					  
					  complete: function(statusText,status){
						  removeLoadingWs();
						  doAction('search');
					  },
					  
					  error: function(rtnMsg){
						  alert(JSON.stringify(rtnMsg));
					  }
				    }
				);			
			}
			function cmp_fam(){
				var f = document.ormsForm;
				var add_html = "";
				if(mySheet.GetDataFirstRow()>=0){
					for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
						if(mySheet.GetCellValue(j,"ischeck")==1){
							add_html += "<input type='hidden' name='sch_bas_ym' value='" + mySheet.GetCellValue(j,"bas_ym") + "'>";
						}
					}
				}

				//alert(add_html);			
				
				if(add_html==""){
					alert("결재할 평판지표를 선택하세요.");
					return;
				}

	            tmp_area.innerHTML = add_html;
				
				
				var f = document.ormsForm;
				if(!confirm("선택한 평판지표를 결재 하시겠습니까?")) return;
				
				<%if(rep_menu_dsc.equals("1")) { %>
					$('#chk_auth').val('13');
				<%}else if(rep_menu_dsc.equals("2")) { %>
					$('#chk_auth').val('14');
				<%} %>
					
				WP.clearParameters();
				WP.setParameter("method", "Main");
				WP.setParameter("commkind", "fam");
				WP.setParameter("process_id", "ORFM011104");  //ORFM011104
				WP.setForm(f);
				
				var url = "<%=System.getProperty("contextpath")%>/comMain.do";
				var inputData = WP.getParams();
				
				//alert(inputData);
				
				showLoadingWs(); // 프로그래스바 활성화
				WP.load(url, inputData,
				    {
					  success: function(result){
						  if(result != 'undefined' && result.rtnCode== 'S'){
							  alert(result.rtnMsg);
							  doAction('search');
						  }
						  
					  },
					  
					  complete: function(statusText,status){
						  removeLoadingWs();
						  doAction('search');
					  },
					  
					  error: function(rtnMsg){
						  alert(JSON.stringify(rtnMsg));
					  }
				    }
				);			
			}
			function rtn_fam(){
				var f = document.ormsForm;
				var add_html = "";
				if(mySheet.GetDataFirstRow()>=0){
					for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
						if(mySheet.GetCellValue(j,"ischeck")==1){
							add_html += "<input type='hidden' name='sch_bas_ym' value='" + mySheet.GetCellValue(j,"bas_ym") + "'>";
							add_html += "<input type='hidden' name='sch_rtn_cntn' value='" + mySheet.GetCellValue(j,"rtn_cntn") + "'>";
						}
					}
				}

				//alert(add_html);			
				
				if(add_html==""){
					alert("반려 할 평판지표를 선택하세요.");
					return;
				}

	            tmp_area.innerHTML = add_html;
				
				
				var f = document.ormsForm;
				if(!confirm("선택한 평판지표를 반려 하시겠습니까?")) return;
					
				WP.clearParameters();
				WP.setParameter("method", "Main");
				WP.setParameter("commkind", "fam");
				WP.setParameter("process_id", "ORFM011105");  //ORFM011104
				WP.setForm(f);
				
				var url = "<%=System.getProperty("contextpath")%>/comMain.do";
				var inputData = WP.getParams();
				
				//alert(inputData);
				
				showLoadingWs(); // 프로그래스바 활성화
				WP.load(url, inputData,
				    {
					  success: function(result){
						  if(result != 'undefined' && result.rtnCode== 'S'){
							  alert(result.rtnMsg);
							  doAction('search');
						  }
						  
					  },
					  
					  complete: function(statusText,status){
						  removeLoadingWs();
						  doAction('search');
					  },
					  
					  error: function(rtnMsg){
						  alert(JSON.stringify(rtnMsg));
					  }
				    }
				);			
			}
		
			function monthChange() {
				var selectYear = $("#sch_bas_y_a").val();
				var change=[];
<%
				for(int i=0; i<vLst.size(); i++) {
					HashMap hMap2 = (HashMap)vLst.get(i);
					String bas_ym2 = new String((String)hMap2.get("bas_ym"));
					String bas_y2 = bas_ym2.substring(0,4);
					String bas_m2 = bas_ym2.substring(4,6);
					%>
					if(selectYear==<%=bas_y2%>){
						if(<%=bas_m2%> < 10) change.push('0'+<%=bas_m2%>);
						else change.push(<%=bas_m2%>);
					}
					<%
				}
%>
				//alert(change.length);
				$('#sch_bas_m_a').empty();
				for(var count=0; count<change.length; count++){
					var option = $("<option>"+change[count]+"</option>");
					$('#sch_bas_m_a').append(option);
				}    
			}
			function monthChange2() {
				var selectYear = $("#sch_bas_y_b").val();
				var change=[];
<%
				for(int i=0; i<vLst.size(); i++) {
					HashMap hMap2 = (HashMap)vLst.get(i);
					String bas_ym2 = new String((String)hMap2.get("bas_ym"));
					String bas_y2 = bas_ym2.substring(0,4);
					String bas_m2 = bas_ym2.substring(4,6);
					%>
					if(selectYear==<%=bas_y2%>){
						if(<%=bas_m2%> < 10) change.push('0'+<%=bas_m2%>);
						else change.push(<%=bas_m2%>);
					}
					<%
				}
%>
				//alert(change.length);
				$('#sch_bas_m_b').empty();
				for(var count=0; count<change.length; count++){
					var option = $("<option>"+change[count]+"</option>");
					$('#sch_bas_m_b').append(option);
				}    
			}
		</script>
	</head>
	
	<body>
		<div class="container">
			<!-- page-header -->
			<%@ include file="../comm/header.jsp" %>
			<!--.page header //-->
			<!-- content -->
			<div class="content">
			<form name="ormsForm">
				<input type="hidden" id="path" name="path" />
				<input type="hidden" id="process_id" name="process_id" />
				<input type="hidden" id="commkind" name="commkind" />
				<input type="hidden" id="method" name="method" />
				<input type="hidden" id="bas_ym" name="bas_ym" />
				<input type="hidden" id="chk_auth" name="chk_auth" />
				
				<input type="hidden" id="table_name" name="table_name" value="TB_OR_FH_CPTAM_DCZ"/>
				<input type="hidden" id="dcz_code" name="stsc_column_name" value="CPTAM_DCZ_STSC"/>
				<input type="hidden" id="rpst_id_column" name="rpst_id_column" value="BAS_YM"/>
				<input type="hidden" id="rpst_id" name="rpst_id" value=""/>
				<input type="hidden" id="bas_pd_column" name="bas_pd_column" value="BAS_YM"/>
				<input type="hidden" id="bas_pd" name="bas_pd" value=""/>
				<input type="hidden" id="dcz_objr_emp_auth" name="dcz_objr_emp_auth" value=""/>
				<input type="hidden" id="sch_rtn_cntn" name="sch_rtn_cntn" value=""/>
				<input type="hidden" id="dcz_objr_eno" name="dcz_objr_eno" value=""/>
				<input type="hidden" id="dcz_rmk_c" name="dcz_rmk_c" value=""/>
				<input type="hidden" id="brc_yn" name="brc_yn" value="Y"/>
				<div id="tmp_area"></div>
				<div class="box box-search">
					<div class="box-body">
						<div class="wrap-search">
							<table>
								<tbody>
									<tr>
										<th>기간설정</th>
										<td>
											<select name="sch_bas_y_a" id="sch_bas_y_a" class="form-control w80" onchange="monthChange()">
<%
		String temp = "";
		for(int i=0;i<vLst.size();i++){
			HashMap hMap = (HashMap)vLst.get(i);
			String bas_ym = new String((String)hMap.get("bas_ym"));
			String bas_y = bas_ym.substring(0,4);
			if(bas_y.equals(temp)) continue; 
			else{
%>
												<option value="<%=bas_y%>"><%=bas_y%></option>
<%			}
			temp = bas_y;
		}
%>

											</select>
											<select name="sch_bas_m_a" id="sch_bas_m_a" class="form-control w60">
<%
		for(int i=0;i<vLst.size();i++){
			HashMap hMap = (HashMap)vLst.get(i);
			String bas_ym = new String((String)hMap.get("bas_ym"));
			String bas_y = bas_ym.substring(0,4);
			String bas_m = bas_ym.substring(4,6);
			if(temp.equals(bas_y)){
%>
												<option value="<%=bas_m%>"><%=bas_m%></option>
<% 
			}
		}
%>												
											</select>
											~
											<select name="sch_bas_y_b" id="sch_bas_y_b" class="form-control w80" onchange="monthChange2()">
<%		temp="";
		for(int i=0;i<vLst.size();i++){
			HashMap hMap = (HashMap)vLst.get(i);
			String bas_ym = new String((String)hMap.get("bas_ym"));
			String bas_y = bas_ym.substring(0,4);
			if(bas_y.equals(temp)) continue; 
			else{
%>
												<option value="<%=bas_y%>" selected><%=bas_y%></option>
<%
			}
			temp = bas_y;
		}
%>

											</select>
											<select name="sch_bas_m_b" id="sch_bas_m_b" class="form-control w60">
<%
		for(int i=0;i<vLst.size();i++){
			HashMap hMap = (HashMap)vLst.get(i);
			String bas_ym = new String((String)hMap.get("bas_ym"));
			String bas_y = bas_ym.substring(0,4);
			String bas_m = bas_ym.substring(4,6);
			if(temp.equals(bas_y)){
%>
												<option value="<%=bas_m%>" selected><%=bas_m%></option>
<% 
			}
		}
%>
													
											</select>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="box-footer">
						<button type="button" class="btn btn-primary search" onclick="doAction('search');">조회</button>
					</div>
				</div>
				
				<section class="box box-grid">
					<div class="box-header">
						<div class="area-tool">
							<div class="btn-group">
								<button type="button" class="btn btn-default btn-xs" id="add_btn" name="add_btn" onClick="doAction('mod1')"><i class="fa fa-plus"></i><span class="txt">신규등록</span></button>
								<button type="button" class="btn btn-default btn-xs" onclick="doAction('del');"><i class="fa fa-minus"></i><span class="txt">삭제</span></button>
							 </div>
							<button class="btn btn-xs btn-default" type="button" onclick="doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
						</div>
					</div>
					<div class="wrap-grid h550" >
						<script> createIBSheet("mySheet", "100%", "100%"); </script>
					</div>
					<div class="box-footer">
						<div class="btn-wrap">
						<%if(rep_menu_dsc.equals("1")) { %>
							<button type="button" class="btn btn-primary" onclick="doAction('sub');" >상신</button>
						<%} %>
						<%if(rep_menu_dsc.equals("2")) { %>
							<button type="button" class="btn btn-primary" onclick="doAction('dcz');" >결재</button>
							<button type="button" class="btn btn-primary" onclick="doAction('ret');" >반려</button>
						<%} %>
						</div>
	                </div>
				</section>
			</form>
			</div>
			<!-- content //-->
			
		</div>
		<!-- popup -->
		<div id="winFamMod" class="popup modal"> <!-- 평판상세 종합INDEX -->
			<iframe name="ifrFamMod" id="ifrFamMod" src="about:blank"></iframe>
		</div>
		<div id="winFamMod1" class="popup modal"> <!-- 평판상세 종합INDEX -->
			<iframe name="ifrFamMod1" id="ifrFamMod1" src="about:blank"></iframe>
		</div>
		<%@ include file="../comm/OrgInfP.jsp" %>
		<%@ include file="../comm/PrssInfP.jsp" %> <!-- 업무프로세스 공통 팝업 --> 
		<%@ include file="../comm/DczP.jsp" %> <!-- 결재 공통 팝업 -->
		<script>
		// 결재팝업 연동 - 결재요청
		function DczSearchEndSub(){
			cmp_fam();
		}
		// 결재팝업 연동 - 결재
		function DczSearchEndCmp(){
			cmp_fam();
		}
		// 결재팝업 연동 - 반려
		function DczSearchEndRtn(){
			rtn_fam();
		}
		// 결재팝업 연동 - 회수
		function DczSearchEndCncl(){
			doCncl();
		}
		</script>
	</body>
</html>