<%--
/*---------------------------------------------------------------------------
 Program ID   : ORAD0108.jsp
 Program name : ADMIN > ADMIN > 메뉴 관리
 Description  : 
 Programer    : 권성학
 Date created : 2021.04.29
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
	Vector vLst1= CommUtil.getResultVector(request, "grp02", 0, "unit01", 0, "vList");
	if(vLst1==null) vLst1 = new Vector();
	System.out.println("vLst1:"+vLst1.toString());
	
	Vector vLst2= CommUtil.getResultVector(request, "grp02", 0, "unit02", 0, "vList");
	if(vLst2==null) vLst2 = new Vector();
	System.out.println("vLst2:"+vLst2.toString());

	String prss_kdc = "";
	String prss_kdc_nm = "";
	
	for(int i=0;i<vLst1.size();i++){
		HashMap hp1 = (HashMap)vLst1.get(i);
		String nm = (String)hp1.get("intg_cnm");
		for(int j=0;j<vLst2.size();j++){
			HashMap hp2 = (HashMap)vLst2.get(j);
			if(nm.equals((String)hp2.get("intgc"))){
				nm = (String)hp2.get("intg_cnm");
				break;
			}
		}
		if(prss_kdc==""){
			prss_kdc += (String)hp1.get("intgc");
			prss_kdc_nm += nm;
		}else{
			prss_kdc += ("|" + (String)hp1.get("intgc"));
			prss_kdc_nm += ("|" + nm);
		}
	}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>
		
		$(document).ready(function(){
			// ibsheet 초기화
			initIBSheet();
			createIBSheet2(document.getElementById("mydiv1"),"mySheet1", "100%", "100%");
			//initIBSheet1();
			//initIBSheet2();
		});

		$(document).ready(function() {
			initIBSheet1();
			createIBSheet2(document.getElementById("mydiv2"),"mySheet2", "100%", "100%");
		});

		$(document).ready(function() {
			initIBSheet2();
		});

		/*Sheet 기본 설정 */
		function initIBSheet() {
			//시트 초기화
			mySheet.Reset();
			
			var initData = {};
			
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0,ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden"};
			initData.Cols = [
 				{Header:"레벨",			Type:"Text",		SaveName:"level",			Hidden:true},
 				{Header:"메뉴ID",			Type:"Text",		SaveName:"menu_id",			Hidden:true},
 				{Header:"메뉴",			Type:"Text",		SaveName:"mnnm",			Align:"Left",	Width:450,	EditLen:50,	MinWidth:100, TreeCol:1, LevelSaveName:"TREELEVEL", TreeCheck:false,	Edit:false},
 				{Header:"메뉴내용",		Type:"Text",		SaveName:"menu_expl",		Hidden:true},
 				{Header:"페이지주소",		Type:"Text",		SaveName:"urlnm",			Hidden:true},
 				{Header:"정렬순서",		Type:"Int",			SaveName:"sort_sq_val", 	Hidden:true},
 				{Header:"도움말주소",		Type:"Text",		SaveName:"hps_urlnm",		Hidden:true},
 				{Header:"상위메뉴ID",		Type:"Text",		SaveName:"up_menu_id",		Hidden:true},
 				{Header:"본부부서여부",		Type:"Text",		SaveName:"hofc_dept_yn",	Hidden:true},
 				{Header:"영업본부여부",		Type:"Text",		SaveName:"biz_hofc_yn",		Hidden:true},
 				{Header:"영업점여부",		Type:"Text",		SaveName:"bizo_yn",			Hidden:true},
 				{Header:"해외부서여부",		Type:"Text",		SaveName:"fr_dept_yn",		Hidden:true},
 				{Header:"운영리스크부서여부",	Type:"Text",		SaveName:"oprk_dept_yn",	Hidden:true},
 				{Header:"BCP부서여부",		Type:"Text",		SaveName:"bcp_dept_yn",		Hidden:true}
   			];
 			IBS_InitSheet(mySheet,initData);
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			//mySheet.SetCountPosition(3);
			mySheet.SetFocusAfterProcess(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			
			mySheet.FitColWidth();
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			//트리컬럼 체크박스 사용시 어미/자식 간의 연관 체크기능 사용
			mySheet.SetTreeCheckActionMode(1); 
			
			doAction('search');
			
		}
		
		function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
		}
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
				case "search":  //데이터 조회
					//var opt = { CallBack : DoSearchEnd };
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("adm");
					$("form[name=ormsForm] [name=process_id]").val("ORAD010802");
					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "down2excel":
					var params = {ExcelHeaderRowHeight:25, ExcelRowHeight:17, ExcelFontSize:10, FileName : "메뉴정보.xlsx",  SheetName : "Sheet1", DownTreeHide:"True"} ;

					//setExcelDownCols("1|2|3|4");
					mySheet.Down2Excel(params);

					break;
				case "save":      //저장할 데이터 추출

					if($("#mode").val() == ""){
						alert("저장할 내역이 없습니다.");
						return;
					}
				
					if($("#mode").val() == "U" && $("#menu_id").val() == ""){
						alert("저장할 내역이 없습니다.");
						return;
					}
					
					if($("#mnnm").val() == ""){
						alert("메뉴명을 입력해 주십시오.");
						$("#mnnm").focus();
						return;
					}

					var prc_html = "";
					if(mySheet1.GetDataFirstRow()>=0){
						for(var j=mySheet1.GetDataFirstRow(); j<=mySheet1.GetDataLastRow(); j++){
							if(trim(mySheet1.GetCellValue(j,"pgid"))==""){
								alert("프로세스ID를 입력해 주십시오.");
								return;
							}
							if(trim(mySheet1.GetCellValue(j,"prss_kdc"))==""){
								alert("commkind를 선택해 주십시오.");
								return;
							}
							prc_html += "<input type='hidden' name='prc_pgid' value='" + mySheet1.GetCellValue(j,"pgid") + "'>";
							prc_html += "<input type='hidden' name='prss_kdc' value='" + mySheet1.GetCellValue(j,"prss_kdc") + "'>";
						}
					}
					prc_area.innerHTML = prc_html;
					
					var pgm_html = "";
					if(mySheet2.GetDataFirstRow()>=0){
						for(var j=mySheet2.GetDataFirstRow(); j<=mySheet2.GetDataLastRow(); j++){
							if(trim(mySheet2.GetCellValue(j,"pgid"))==""){
								alert("프로그램ID를 입력해 주십시오.");
								return;
							}
							pgm_html += "<input type='hidden' name='jsp_pgid' value='" + mySheet2.GetCellValue(j,"pgid") + "'>";
						}
					}
					pgm_area.innerHTML = pgm_html;
					//alert(prc_html);
					//alert(prc_html);
					
					
					if(!confirm("저장하시겠습니까?")) return;
					
					var f = document.ormsForm;
					WP.clearParameters();
					WP.setParameter("method", "Main");
					WP.setParameter("commkind", "adm");
					if($("#mode").val() == "I"){
						WP.setParameter("process_id", "ORAD010804");
					}else if($("#mode").val() == "U"){
						WP.setParameter("process_id", "ORAD010803");
					}else{
						return;
					}
					WP.setForm(f);
					
					var inputData = WP.getParams();
					
					//alert(inputData);
					showLoadingWs(); // 프로그래스바 활성화
					WP.load(url, inputData,
					{
						success: function(result){
							if(result!='undefined' && result.rtnCode=="S") {
								alert("저장되었습니다.");
								objCopy(result.Result.new_code);
							}else if(result!='undefined'){
								alert(result.rtnMsg);
							}else if(result=='undefined'){
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
					
					break;
				case "del":      //삭제
					var srow = mySheet.GetSelectRow();
				
					if(srow < 0) {
						alert("삭제할 메뉴를 선택하세요.");
						return;
					}
					
					if(mySheet.GetChildRows(srow) != ""){
						alert("하위 메뉴가 존재하는 메뉴는 삭제가 불가능합니다.");
						return;
					}
					
					if(mySheet.GetCellValue(srow,"menu_id") == ""){
						mySheet.RowDelete(srow, 0);
						mySheet.SetSelectRow(-1);
						init();
					}else{
					
						if(!confirm("삭제하시겠습니까?")) return;
						
						var f = document.ormsForm;
						WP.clearParameters();
						WP.setParameter("method", "Main");
						WP.setParameter("commkind", "adm");
						WP.setParameter("process_id", "ORAD010805");
						WP.setForm(f);
						
						var inputData = WP.getParams();
						
						showLoadingWs(); // 프로그래스바 활성화
						WP.load(url, inputData,
						{
							success: function(result){
								if(result!='undefined' && result.rtnCode=="S") {
									alert("삭제되었습니다.");
									mySheet.RowDelete(srow, 0);
									mySheet.SetSelectRow(-1);
									init();
								}else if(result!='undefined'){
									alert(result.rtnMsg);
								}else if(result=='undefined'){
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
					
					break;
				case "insert":		//신규행 추가
					var srow = mySheet.GetSelectRow();
				
					if(srow < 0){
						alert("메뉴를 선택해 주십시오.");
						return;
					}
					
					if(mySheet.GetCellText(srow,"menu_id") == ""){
						alert("상위 메뉴를 저장 후 추가하세요.");
						return ;
					}
					
					if(mySheet.GetCellText(srow,"level") == "4"){
						alert("4레벨까지만 등록 가능합니다.");
						return ;
					}
					
					if(mySheet.GetRowExpanded(srow) == 0){
					    mySheet.SetRowExpanded(srow, 1);
					}
					
					var row = mySheet.DataInsert(srow+1, mySheet.GetRowLevel(srow)+1 ); 
					mySheet.SetCellValue(row,"up_menu_id", mySheet.GetCellText(srow,"menu_id"));
					mySheet.SetCellValue(row,"level", Number(mySheet.GetCellText(srow,"level"))+1);
					mySheet.SetCellValue(row,"hofc_dept_yn", "Y");
					mySheet.SetCellValue(row,"biz_hofc_yn", "Y");
					mySheet.SetCellValue(row,"bizo_yn", "Y");
					mySheet.SetCellValue(row,"fr_dept_yn", "Y");
					mySheet.SetCellValue(row,"oprk_dept_yn", "Y");
					mySheet.SetCellValue(row,"bcp_dept_yn", "Y");
					mySheet_OnClick(row);
					break; 
				case "ref":		//초기화
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("adm");
					$("form[name=ormsForm] [name=process_id]").val("ORAD010802");
					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
				
					$("#hofc_dept_yn").attr("disabled",true);
					$("#biz_hofc_yn").attr("disabled",true);
					$("#bizo_yn").attr("disabled",true);
					$("#fr_dept_yn").attr("disabled",true);
					$("#oprk_dept_yn").attr("disabled",true);
					$("#bcp_dept_yn").attr("disabled",true);
					$("#urlnm").attr("disabled",true);
					$("#hps_urlnm").attr("disabled",true);
					$("#menu_id").attr("disabled",true);
					$("#mnnm").attr("disabled",true);
					$("#menu_expl").attr("disabled",true);
					$("#sort_sq_val").attr("disabled",true);
					
					$("#mnnm").val("");
					$("#urlnm").val("");
					$("#menu_expl").val("");
					$("#sort_sq_val").val("");
					$("#hps_urlnm").val("");
					$("#hofc_dept_yn").val("Y");
					$("#biz_hofc_yn").val("Y");
					$("#bizo_yn").val("Y");
					$("#fr_dept_yn").val("Y");
					$("#oprk_dept_yn").val("Y");
					$("#bcp_dept_yn").val("Y");
				
					break; 
				case "search1":  //데이터 조회
					//var opt = { CallBack : DoSearchEnd };
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("adm");
					$("form[name=ormsForm] [name=process_id]").val("ORAD010806");

					mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;

				case "add1":
//					if($("#urlnm").attr("disabled") || $("#menu_id").val()=="" ){
					if($("#urlnm").attr("disabled")){
						//alert("URL이 비활성화 되었거나 메뉴ID가 생성되지 않았습니다.")
						alert("URL이 비활성화 되었습니다.")
						break;
					}
					
					
					var row = mySheet1.DataInsert(0);
					mySheet1.SetCellValue(row,"grp_org_c","<%=grp_org_c%>");
					mySheet1.SetCellValue(row,"menu_id",$("#menu_id").val());
					break;
					
				case "del1":
					for(var i=mySheet1.GetDataLastRow(); i>=mySheet1.GetDataFirstRow(); i--){
						if(mySheet1.GetCellValue(i,"ischeck") == "1"){
							mySheet1.RowDelete(i,0);
						}
					}
					break;
					
				case "search2":  //데이터 조회
					//var opt = { CallBack : DoSearchEnd };
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("adm");
					$("form[name=ormsForm] [name=process_id]").val("ORAD010807");

					mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;

				case "add2":
					//if($("#urlnm").attr("disabled") || $("#menu_id").val()=="" ){
					if($("#urlnm").attr("disabled")){
						//alert("URL이 비활성화 되었거나 메뉴ID가 생성되지 않았습니다.")
						alert("URL이 비활성화 되었습니다.")
						break;
					}
					var row = mySheet2.DataInsert(0);
					mySheet2.SetCellValue(row,"grp_org_c","<%=grp_org_c%>");
					mySheet2.SetCellValue(row,"menu_id",$("#menu_id").val());
					break;
					
				case "del2":
					for(var i=mySheet2.GetDataLastRow(); i>=mySheet2.GetDataFirstRow(); i--){
						if(mySheet2.GetCellValue(i,"ischeck") == "1"){
							mySheet2.RowDelete(i,0);
						}
					}
					break;
				<%-- case "sync":
					if(!confirm("프로세스/서비스를 동기화 하시겠습니까?")) return;
					
					var f = document.ormsForm;
					WP.clearParameters();
					var inputData = WP.getParams();
					//alert(inputData);
					showLoadingWs(); // 프로그래스바 활성화
					WP.load("<%=System.getProperty("contextpath")%>/syncprsssvc.do", inputData,
					{
						success: function(result){
							if(result!='undefined' && result.rtnCode=="0") {
								alert("프로세스/서비스가 동기화 되었습니다.");
							}else if(result!='undefined'){
								alert(result.rtnMsg);
							}else if(result=='undefined'){
								alert("처리할 수 없습니다.");
							}else{
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
					break; --%>
			}
		}
		
		var select_menus = new Array();
		function mySheet_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다.");
			}else{
				
			}
			mySheet.ShowTreeLevel(2,1);
			mySheet.FitColWidth();
			
			//menu_select();
		}
		
		function menu_select() {
			if(select_menus.length>0){
				var obj = select_menus.pop();
				if(obj["menu_id"] == ""){
					var st_idx = 0;
					for(var i =0;i<10;i++){
						var Row1 = mySheet.FindText("up_menu_id", obj["up_menu_id"], st_idx, -1, 0);
						if(Row1<0) break;
						if(mySheet.GetCellValue(Row1,"mnnm") == obj["mnnm"]){
							//mySheet.SelectCell(Row1,"mnnm");
							mySheet.SetSelectRow(Row1,1);
							break;
						}
						st_idx = Row1 + 1;
					}
				}else{
					var Row1 = mySheet.FindText("menu_id", obj.menu_id, 0, -1, 0);
					mySheet.SetSelectRow(Row1,1);
				}
			}
			if(select_menus.length>0) setTimeout(menu_select,1)
		
		}
		function mySheet_OnSaveEnd(code, msg) {
		}
		
		function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			if(Row >= mySheet.GetDataFirstRow()){
				init();
				
				if(mySheet.GetCellValue(Row,"level") == "4"){
					//$("#hofc_dept_yn").attr("disabled",false);
					//$("#biz_hofc_yn").attr("disabled",false);
					//$("#bizo_yn").attr("disabled",false);
					//$("#fr_dept_yn").attr("disabled",false);
					//$("#oprk_dept_yn").attr("disabled",false);
					//$("#bcp_dept_yn").attr("disabled",false);
					$("#urlnm").attr("disabled",false);
					$("#hps_urlnm").attr("disabled",false);
					
					$("#urlnm").val(mySheet.GetCellValue(Row,"urlnm"));
					$("#hps_urlnm").val(mySheet.GetCellValue(Row,"hps_urlnm"));
				}
				
				$("#hofc_dept_yn").attr("disabled",false);
				$("#biz_hofc_yn").attr("disabled",false);
				$("#bizo_yn").attr("disabled",false);
				$("#fr_dept_yn").attr("disabled",false);
				$("#oprk_dept_yn").attr("disabled",false);
				$("#bcp_dept_yn").attr("disabled",false);
				
				$("#hofc_dept_yn").val(mySheet.GetCellValue(Row,"hofc_dept_yn"));
				$("#biz_hofc_yn").val(mySheet.GetCellValue(Row,"biz_hofc_yn"));
				$("#bizo_yn").val(mySheet.GetCellValue(Row,"bizo_yn"));
				$("#fr_dept_yn").val(mySheet.GetCellValue(Row,"fr_dept_yn"));
				$("#oprk_dept_yn").val(mySheet.GetCellValue(Row,"oprk_dept_yn"));
				$("#bcp_dept_yn").val(mySheet.GetCellValue(Row,"bcp_dept_yn"));
				
				$("#menu_id").attr("disabled",false);
				$("#mnnm").attr("disabled",false);
				$("#menu_expl").attr("disabled",false);
				$("#sort_sq_val").attr("disabled",false);
				
				$("#menu_id").val(mySheet.GetCellValue(Row,"menu_id"));
				$("#up_menu_id").val(mySheet.GetCellValue(Row,"up_menu_id"));
				$("#mnnm").val(mySheet.GetCellValue(Row,"mnnm"));
				$("#menu_expl").val(mySheet.GetCellValue(Row,"menu_expl"));
				$("#sort_sq_val").val(mySheet.GetCellValue(Row,"sort_sq_val"));
				
				if(mySheet.GetCellValue(Row,"menu_id") == ""){
					$("#mode").val("I");
				}else{
					$("#mode").val("U");
				}
				
				mySheet.SetBlur();
				$("#mnnm").focus();
				
				doAction("search1");
				doAction("search2");

					
			}
		}
		
		function onChange(sAction) {
			var sRow = mySheet.GetSelectRow();
			if(sRow < 0) return;
			
			mySheet.SetCellValue(sRow,sAction,$("#"+sAction+"").val());
		}
		
		function init(){
			$("#mnnm").val("");
	    	$("#urlnm").val("");
	    	$("#menu_expl").val("");
	    	$("#sort_sq_val").val("");
	    	$("#hps_urlnm").val("");
	    	$("#hofc_dept_yn").val("");
	    	$("#biz_hofc_yn").val("");
	    	$("#bizo_yn").val("");
	    	$("#fr_dept_yn").val("");
	    	$("#oprk_dept_yn").val("");
	    	$("#bcp_dept_yn").val("");
	    	$("#mode").val("");
	    	$("#menu_id").val("");
	    	$("#up_menu_id").val("");
	    	
	    	$("#mnnm").attr("disabled",true);
			$("#urlnm").attr("disabled",true);
			$("#menu_expl").attr("disabled",true);
			$("#sort_sq_val").attr("disabled",true);
			$("#hps_urlnm").attr("disabled",true);
			$("#hofc_dept_yn").attr("disabled",true);
			$("#biz_hofc_yn").attr("disabled",true);
			$("#bizo_yn").attr("disabled",true);
			$("#fr_dept_yn").attr("disabled",true);
			$("#oprk_dept_yn").attr("disabled",true);
			$("#bcp_dept_yn").attr("disabled",true);
		}
		
		function objCopy(new_code){
			var srow = mySheet.GetSelectRow();
			
			if($("#mode").val() == "I"){
				mySheet.SetCellValue(srow, "menu_id", new_code);
				$("#menu_id").val(new_code);
				$("#mode").val("U");
			}
		}

		
		// 메뉴 프로세스 매핑
		/*Sheet 기본 설정 */
		function initIBSheet1() {
			//시트 초기화
			mySheet1.Reset();
			
			var initData = {};
			initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden|colresize"}; //좌측에 고정 컬럼의 수
			initData.Cols = [
			 	{Header:"상태",Type:"Status",Width:50,Align:"Center",HAlign:"Center",SaveName:"status",MinWidth:40,Edit:false,Hidden:true},
				{Header:"선택",Type:"CheckBox",Width:50,Align:"Center",SaveName:"ischeck",MinWidth:40},		    
			    {Header:"그룹코드",Type:"Text",Width:150,Align:"Left",SaveName:"grp_org_c",MinWidth:60, Hidden:true, Edit:false, Wrap:true},				    
			    {Header:"메뉴ID",Type:"Text",Width:150,Align:"Left",SaveName:"menu_id",MinWidth:60, Hidden:true, Edit:false, Wrap:true},				    
			    {Header:"프로세스그룹",Type:"Combo",Width:150,Align:"Left",SaveName:"prss_kdc",MinWidth:40, Edit:true,ComboText:"|<%=prss_kdc_nm%>",ComboCode:"|<%=prss_kdc%>"},
				{Header:"프로세스ID",Type:"Text",Width:150,Align:"Left",SaveName:"pgid",MinWidth:40, Edit:true}
			];
			IBS_InitSheet(mySheet1,initData);
			
			//필터표시
			//mySheet1.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet1.SetCountPosition(3);
			
			mySheet1.SetFocusAfterProcess(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet1.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			//헤더기능 해제
			mySheet1.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
			
			//doAction('search');
			
		}

		function mySheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			//alert(Row);
		}
		
		function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
		}
		
		function mySheet1_OnRowSearchEnd (Row) {
			mySheet1.SetCellValue(Row,"status","");
		}
		
		// 메뉴 JSP 매핑
		/*Sheet 기본 설정 */
		function initIBSheet2() {
			//시트 초기화
			mySheet2.Reset();
			
			var initData = {};
			initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden|colresize"}; //좌측에 고정 컬럼의 수
			initData.Cols = [
			 	{Header:"상태",Type:"Status",Width:50,Align:"Center",HAlign:"Center",SaveName:"status",MinWidth:40,Edit:false,Hidden:true},
				{Header:"선택",Type:"CheckBox",Width:50,Align:"Center",SaveName:"ischeck",MinWidth:40},		    
			    {Header:"그룹코드",Type:"Text",Width:150,Align:"Left",SaveName:"grp_org_c",MinWidth:60, Hidden:true, Edit:false, Wrap:true},				    
			    {Header:"메뉴ID",Type:"Text",Width:150,Align:"Left",SaveName:"menu_id",MinWidth:60, Hidden:true, Edit:false, Wrap:true},				    
				{Header:"프로그램ID",Type:"Text",Width:350,Align:"Left",SaveName:"pgid",MinWidth:40, Edit:true}
			];
			IBS_InitSheet(mySheet2,initData);
			
			//필터표시
			//mySheet2.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet2.SetCountPosition(3);
			
			mySheet2.SetFocusAfterProcess(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet2.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			//헤더기능 해제
			mySheet2.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
			
			//doAction('search');
			
		}

		function mySheet2_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			//alert(Row);
		}
		
		function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
		}
		
		function mySheet2_OnRowSearchEnd (Row) {
			mySheet2.SetCellValue(Row,"status","");
		}
		function mySheet_showAllTree(flag){
			if(flag == 1){
				mySheet.ShowTreeLevel(-1);
			}else if(flag == 2){
				mySheet.ShowTreeLevel(0,1);
			}
		}
	</script>

</head>
<body>
	<div class="container">
		<!-- Content Header (Page header) -->
		<%@ include file="../comm/header.jsp" %>

		<div class="content">
			<form name="ormsForm">
				<input type="hidden" id="path" name="path" />
				<input type="hidden" id="process_id" name="process_id" />
				<input type="hidden" id="commkind" name="commkind" />
				<input type="hidden" id="method" name="method" />
				<input type="hidden" id="mode" name="mode" />
				<input type="hidden" id="menu_id" name="menu_id" />
				<input type="hidden" id="up_menu_id" name="up_menu_id" />
				<div id="prc_area"></div>
				<div id="pgm_area"></div>
				<div class="row">
					<div class="col col-xs-5">
						<div class="box box-grid">
							<div class="box-header">
								<div class="area-tool">
									<button type="button" class="btn btn-default btn-xs" onclick="javascript:doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
								</div>
							</div>
							<div>
						<table>
							<tr>
								<td>
								    <button type="button" class="btn btn-xs btn-default" onClick="javascript:mySheet_showAllTree('1');"><i class="fa fa-plus"></i><span class="txt">모두 펼치기</span></button>
									<button type="button" class="btn btn-xs btn-default" onClick="javascript:mySheet_showAllTree('2');"><i class="fa fa-minus"></i><span class="txt">모두 접기</span></button>
								</td>
							</tr>
						</table>
					</div>
							<div class="box-body">
								<div class="wrap-grid h550">
									<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%"); </script>
								</div>
							</div>
							<div class="box-footer">
								<div class="btn-wrap">
									<%-- <button type="button" class="btn btn-default btn-sm" onclick="javascript:doAction('sync')"><i class="fa fa-refresh"></i><span class="txt">프로세스/서비스 동기화</span></button> --%>
									<button type="button" class="btn btn-default btn-sm" onclick="javascript:doAction('insert')"><i class="fa fa-plus"></i><span class="txt">하위 메뉴 추가</span></button>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-xs-7">
						<div class="box box-grid">
							<div class="box-header">
								<h3 class="box-title">메뉴등록/수정</h3>
							</div>
							<div class="wrap-table">
								<table>
									<colgroup>
										<col style="width:160px" />
										<col  />
										<col style="width:160px" />
										<col  />
									</colgroup>
									<tbody>
										<tr>
											<th><label class="" for="mnnm">메뉴명</label></th>
											<td colspan="3">
												<input type="text" class="form-control" id="mnnm" name="mnnm" value="" maxlength="100" onchange="javascript:onChange('mnnm');" disabled/>
											</td>
										</tr>
										<tr>
											<th><label class="" for="urlnm">URL</label></th>
											<td colspan="3">
												<input type="text" class="form-control" id="urlnm" name="urlnm" value="" maxlength="500" onchange="javascript:onChange('urlnm');" disabled />
											</td>
										</tr>
										<tr>
											<th><label class="" for="menu_expl">설명</label></th>
											<td colspan="3">
												<textarea class="form-control textarea" id="menu_expl" name="menu_expl" maxlength="255" onchange="javascript:onChange('menu_expl');" disabled></textarea>
											</td>
										</tr>
										<tr>
											<th><label class="" for="sort_sq_val">정렬 순서</label></th>
											<td colspan="3">
												<input type="text" class="form-control" id="sort_sq_val" name="sort_sq_val" value="" oninput="this.value=this.value.replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');" maxlength="2" onchange="javascript:onChange('sort_sq_val');" disabled />
											</td>
										</tr>
										<tr>
											<th><label class="" for="hps_urlnm">도움말 URL</label></th>
											<td colspan="3">
												<input type="text" class="form-control" id="hps_urlnm" name="hps_urlnm" value="" maxlength="500" onchange="javascript:onChange('hps_urlnm');" disabled />
											</td>
										</tr>
										<tr>
											<th><label class="" for="hofc_dept_yn">본부부서여부</label></th>
											<td>
												<span class="select ib">
													<select class="form-control" id="hofc_dept_yn" name="hofc_dept_yn" onchange="javascript:onChange('hofc_dept_yn');" disabled>
														<option value="Y">Y</option>
														<option value="N">N</option>
													</select>
												</span>
											</td>
											<th><label class="" for="biz_hofc_yn">영업본부여부</label></th>
											<td>
												<span class="select ib">
													<select class="form-control" id="biz_hofc_yn" name="biz_hofc_yn" onchange="javascript:onChange('biz_hofc_yn');" disabled>
														<option value="Y">Y</option>
														<option value="N">N</option>
													</select>
												</span>
											</td>
										</tr>
										<tr>
											<th><label class="" for="bizo_yn">영업점여부</label></th>
											<td>
												<span class="select ib">
													<select class="form-control" id="bizo_yn" name="bizo_yn" onchange="javascript:onChange('bizo_yn');" disabled>
														<option value="Y">Y</option>
														<option value="N">N</option>
													</select>
												</span>
											</td>
											<th><label class="" for="fr_dept_yn">해외부서여부</label></th>
											<td>
												<span class="select ib">
													<select class="form-control" id="fr_dept_yn" name="fr_dept_yn" onchange="javascript:onChange('fr_dept_yn');" disabled>
														<option value="Y">Y</option>
														<option value="N">N</option>
													</select>
												</span>
											</td>
										</tr>
										<tr>
											<th><label class="" for="oprk_dept_yn">운영리스크부서여부</label></th>
											<td>
												<span class="select ib">
													<select class="form-control" id="oprk_dept_yn" name="oprk_dept_yn" onchange="javascript:onChange('oprk_dept_yn');" disabled>
														<option value="Y">Y</option>
														<option value="N">N</option>
													</select>
												</span>
											</td>
											<th><label class="" for="bcp_dept_yn">BCP부서여부</label></th>
											<td>
												<span class="select ib">
													<select class="form-control" id="bcp_dept_yn" name="bcp_dept_yn" onchange="javascript:onChange('bcp_dept_yn');" disabled>
														<option value="Y">Y</option>
														<option value="N">N</option>
													</select>
												</span>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="row">
								<div class="col col-xs-6">
									<div class="box box-grid">
										<div class="box-header">
											<h3 class="box-title">프로세스매핑</h3>
											<div class="area-tool">
												<div class="btn-group">
													<button class="btn btn-default btn-xs" type="button" onClick="javascript:doAction('add1');"><i class="fa fa-plus"></i><span class="txt">등록</span></button>
													<button class="btn btn-default btn-xs" type="button" onClick="javascript:doAction('del1');"><i class="fa fa-minus"></i><span class="txt">삭제</span></button>
												</div>
											</div>
										</div>
										<div class="box-body">
											<div id="mydiv1" class="wrap-grid h200">
												<!-- <script type="text/javascript"> createIBSheet("mySheet1", "100%", "100%"); </script> -->
											</div>
										</div>
									</div>
								</div>
								<div class="col col-xs-6">
									<div class="box box-grid">
										<div class="box-header">
											<h3 class="box-title">프로그램(JSP)매핑</h3>
											<div class="area-tool">
												<div class="btn-group">
													<button class="btn btn-default btn-xs" type="button" onClick="javascript:doAction('add2');"><i class="fa fa-plus"></i><span class="txt">등록</span></button>
													<button class="btn btn-default btn-xs" type="button" onClick="javascript:doAction('del2');"><i class="fa fa-minus"></i><span class="txt">삭제</span></button>
												</div>
											</div>
										</div>
										<div class="box-body">
											<div id="mydiv2" class="wrap-grid h200">
												<!-- <script type="text/javascript"> createIBSheet("mySheet2", "100%", "100%"); </script> -->
											</div>
										</div>
									</div>
								</div>
							</div><!-- .row //-->
							<div class="box-footer">
								<div class="btn-wrap right">
									<button type="button" id="btnSave" class="btn btn-primary" onclick="javascript:doAction('save')">
										<span class="txt">저장</span>
									</button>
									<button type="button" id="btnDel" class="btn btn-default" onclick="javascript:doAction('del')">
										<span class="txt">삭제</span>
									</button>
								</div>
							</div>
						</div><!-- 메뉴등록/수정 //-->
					</div>
				</div><!-- .row //-->
			</form>
		</div><!-- .content //-->
	</div><!-- .container //-->		
</body>
</html>