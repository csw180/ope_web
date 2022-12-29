<%--
/*---------------------------------------------------------------------------
 Program ID   : ORLS0118.jsp
 Program name : 계정 및 잔액변동 모니터링 (일반사용자용)
 Description  : 
 Programer    : 김남원
 Date created : 2022.04.15
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@page import="com.shbank.orms.comm.SysDateDao"%>
<%@ include file="../comm/comUtil.jsp" %>
<%

//CommUtil.getCommonCode() -> 공통코드조회 메소드
Vector vLssAcgAcccLst = CommUtil.getCommonCode(request, "LSS_ACG_ACCC");
if(vLssAcgAcccLst==null) vLssAcgAcccLst = new Vector();
Vector vXRsnCttLst = CommUtil.getCommonCode(request, "X_RSNCTT");
if(vXRsnCttLst==null) vXRsnCttLst = new Vector();


HashMap hMap2 = (HashMap)request.getSession(true).getAttribute("infoH");



String x_rsnc = "";
String x_rsnctt = "";

for(int i=0;i<vXRsnCttLst.size();i++){
	HashMap hp = (HashMap)vXRsnCttLst.get(i);
	if(x_rsnc==""){
		x_rsnc += (String)hp.get("intgc");
		x_rsnctt += (String)hp.get("intg_cnm");
	}else{
		x_rsnc += ("|" + (String)hp.get("intgc"));
		x_rsnctt += ("|" + (String)hp.get("intg_cnm"));
	}
}
System.out.println(x_rsnctt);


SysDateDao dao = new SysDateDao(request);
String st_dt = dao.getSysdate();
String txt_st_dt = dao.getSysdate();

//오늘날짜로부터 1년후 계산
java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMdd");
Calendar cal = Calendar.getInstance();
java.util.Date date = sdf.parse(st_dt);
cal.setTime(date);
cal.add(Calendar.DATE, -1);
st_dt = sdf.format(cal.getTime());
txt_st_dt = st_dt.substring(0,4)+"-"+st_dt.substring(4,6)+"-"+st_dt.substring(6,8);


%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<%@ include file="../comm/library.jsp" %>
		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<script>
		$(document).ready(function(){

			// ibsheet 초기화
			initIBSheet();
			
			});
			
			/*Sheet 기본 설정 */
			function initIBSheet() {
				//시트 초기화
				mySheet.Reset();
				
				var initData = {};
				
				initData.Cfg = {MergeSheet:msHeaderOnly, AutoFitColWidth:"init|search" };
				initData.Cols = [
				 	{Header:"",				Type:"CheckBox",SaveName:"ischeck",						MinWidth:20,Align:"Left"},
				    {Header:"상태",			Type:"Status",	SaveName:"status",		Hidden:true,	MinWidth:30,Align:"center"},
				    {Header:"No",			Type:"Seq",		SaveName:"rw_no",		Hidden:true,	MinWidth:30,Align:"center"},
				    {Header:"그룹기관코드",		Type:"Text",	SaveName:"grp_org_c",	Hidden:true},
				    {Header:"사건관리법인",		Type:"Text",	SaveName:"grp_org_cnm",					MinWidth:100,Align:"Left", Edit:false},
				    {Header:"거래일련번호",		Type:"Text",	SaveName:"tr_sqno",		Hidden:true},
				    {Header:"계정일련번호",		Type:"Text",	SaveName:"acc_sqno",	Hidden:true},//6
				    {Header:"회계처리일자",		Type:"Date",	SaveName:"acg_prc_dt",					MinWidth:90,Align:"center",Format:"yyyyMMdd"},
				    {Header:"부서코드",			Type:"Text",	SaveName:"brc",			Hidden:true,	MinWidth:120},
				    {Header:"부서\n(영업점)",	Type:"Text",	SaveName:"brnm",						MinWidth:80,Align:"center"},
				    {Header:"거래구분",			Type:"Combo",	SaveName:"crc_can_dsc", 				MinWidth:60,Align:"Center", 					ComboText:"정상|정정|취소|원인거래정정|원인거래취소", ComboCode:"0|1|2|3|4"},
				    {Header:"차대",			Type:"Combo",	SaveName:"rvpy_dsc", 					MinWidth:40,Align:"Center", 					ComboText:"입금|지급", ComboCode:"1|2"},
				    {Header:"계정과목명",		Type:"Text",	SaveName:"acc_sbjnm",					MinWidth:150,Align:"Left"},//12
				    {Header:"손실회계계정코드",	Type:"Text",	SaveName:"lss_acg_accc",				MinWidth:150,Align:"Left"},
				    {Header:"거래내용",			Type:"Text",	SaveName:"tr_cntn",						MinWidth:180,Align:"Left",Wrap:true},
				    {Header:"금액",			Type:"Int",		SaveName:"am",							MinWidth:90,Align:"Right"},
				    {Header:"처리상태",			Type:"Combo",	SaveName:"lss_prc_sts_yn",				MinWidth:80,Align:"Center",						ComboText:"완료|미완료", ComboCode:"Y|N",PopupText:"완료|미완료", Edit:false},
				    {Header:"사건등록\n요청여부",	Type:"Combo",	SaveName:"lss_rg_rqr_stsc",				MinWidth:80,Align:"Center",						ComboText:"-|등록요청|등록불필요", ComboCode:"|01|02",PopupText:"-|등록요청|등록불필요", Edit:false},
				    {Header:"등록요청일",		Type:"Date",	SaveName:"lss_rg_rqr_dt",				MinWidth:90,Align:"center",Format:"yyyyMMdd"},
				    {Header:"사건등록여부",		Type:"Combo",	SaveName:"lss_rg_stsc",					MinWidth:90,Align:"Center",						ComboText:"-|등록|등록불필요", ComboCode:"|01|02",PopupText:"-|등록|등록불필요"},
				    {Header:"금액종류",			Type:"Combo",	SaveName:"acc_dsc",						MinWidth:100,Align:"Center",							ComboText:"", ComboCode:"", Edit:false},
				    {Header:"등록불필요사유",		Type:"Text",	SaveName:"x_rsnctt",					MinWidth:170,Align:"Left",						ComboText:"<%=x_rsnctt%>"}
				];
				
				IBS_InitSheet(mySheet,initData);
				
				//필터표시
				//mySheet.ShowFilterRow();  
				
				//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
				mySheet.SetCountPosition(3);
				
				// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
				// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				mySheet.SetSelectionMode(4);
				
				//마우스 우측 버튼 메뉴 설정
				//setRMouseMenu(mySheet);
				
				//doAction('search');
				
			}
			
			function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
				//alert(Row);
				$("#ocu_brc").val(mySheet.GetCellValue(Row,"brc"));					

			}
			
			function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
				$("#ocu_brc").val(mySheet.GetCellValue(Row,"brc"));

			}
			
			function mySheet_OnChange(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
				if(mySheet.GetCellProperty(Row, Col, "SaveName")=="lss_rg_stsc" ){	//드랍다운 선택시
					if(mySheet.GetCellValue(Row, Col)=="02"){							//등록불필요선택시
						var info = {};
						info = {ComboText:"", ComboCode: "" };
						mySheet.SetCellEditable(Row, "acc_dsc",0);
						mySheet.CellComboItem(Row,"acc_dsc", info);
						mySheet.SetCellValue(Row, "acc_dsc", "선택"); 
						mySheet.SetCellEditable(Row, "x_rsnctt",1);
						for(var i = mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
							if(mySheet.GetCellValue(i, "ischeck")=="1"&&mySheet.GetCellValue(i, "lss_rg_stsc")=="01"){				//이미등록된 사건 선택시 경고
								alert("등록된 사건이 선택되었습니다.");
								mySheet.SetCellValue(i, "ischeck","0");
								return;
							}
						}
					}else if(mySheet.GetCellValue(Row, Col)=="01"){					//드랍다운 등록진행 선택시
						var info = {};
						if(mySheet.GetCellValue(Row,"rvpy_dsc") == "1"){
							info = {ComboText: "선택하세요|손실회수금액|보험회수금액|소송회수금액|기타회수금액", ComboCode: "|1|2|3|4" };
							mySheet.SetCellEditable(Row, "acc_dsc",1);
							mySheet.CellComboItem(Row,"acc_dsc", info);
							mySheet.SetCellValue(Row, "acc_dsc", "선택"); 
							mySheet.SetCellValue(Row, "lss_rg_stsc", "01"); 
						}else if(mySheet.GetCellValue(Row,"rvpy_dsc") == "2"){
							info = {ComboText:"선택하세요|손실발생금액|소송부대비용|기타부대비용", ComboCode: "|1|3|4" };
							mySheet.SetCellEditable(Row, "acc_dsc",1);
							mySheet.CellComboItem(Row,"acc_dsc", info);
							mySheet.SetCellValue(Row, "acc_dsc", "선택"); 
							mySheet.SetCellValue(Row, "lss_rg_stsc", "01"); 
						}
					}else {
						var info = {};
						info = {ComboText:"", ComboCode: "" };
						mySheet.SetCellEditable(Row, "acc_dsc",0);
						mySheet.CellComboItem(Row,"acc_dsc", info);
						mySheet.SetCellValue(Row, "acc_dsc", "선택"); 
						mySheet.SetCellValue(Row, "x_rsnctt","");
						mySheet.SetCellEditable(Row, "x_rsnctt",0);
					}

				}else if(mySheet.GetCellProperty(Row, Col, "SaveName")=="acc_dsc" && mySheet.GetCellValue(Row, Col)!=""){	//금액종류 선택시
					mySheet.SetCellValue(Row, "x_rsnctt", ""); 
					mySheet.SetCellEditable(Row, "x_rsnctt",0);
/*
					$("#acc_sqno").val(mySheet.GetCellValue(Row, "acc_sqno"));
					$("#lss_acg_accc").val(mySheet.GetCellValue(Row, "lss_acg_accc"));
					$("#crc_can_dsc").val(mySheet.GetCellValue(Row, "crc_can_dsc"));
					$("#acg_prc_dt").val(mySheet.GetCellValue(Row, "acg_prc_dt"));
					$("#am").val(mySheet.GetCellValue(Row, "am"));
					$("#tr_cntn").val(mySheet.GetCellValue(Row, "tr_cntn"));
					$("#rvpy_dsc").val(mySheet.GetCellValue(Row, "rvpy_dsc"));
					$("#brc").val(mySheet.GetCellValue(Row, "brc"));
					$("#ocu_brc").val(mySheet.GetCellValue(Row, "brc"));
					$("#acc_dsc").val(mySheet.GetCellValue(Row, "acc_dsc"));
					
					
					//$("#ifrLossAdd").attr("src","about:blank");
					$("#winLossAdd").show();
					var f = document.ormsForm;
					f.method.value="Main";
			        f.commkind.value="los";
			        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
			        f.process_id.value="ORLS010301";
					f.target = "ifrLossAdd";
					f.submit();
*/			


				}
			}
			
			function register(){
				
			}
			
			var row = "";
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
						
			/*Sheet 각종 처리*/
			function doAction(sAction) {
				switch(sAction) {
					case "search":  //데이터 조회
						var opt = {};
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("los");
						$("form[name=ormsForm] [name=process_id]").val("ORLS011802");
						ormsForm.st_dt.value = ormsForm.txt_st_dt.value.replace(/-/gi,"");
						ormsForm.ed_dt.value = ormsForm.txt_ed_dt.value.replace(/-/gi,"");
						if(ormsForm.txt_st_am.value==""){
							ormsForm.st_am.value = "";
						}else if(ormsForm.txt_st_am.value!=""){
							ormsForm.st_am.value = ormsForm.txt_st_am.value.replace(/,/gi,"") * 10000;
						}
						if(ormsForm.txt_ed_am.value==""){
							ormsForm.ed_am.value = "";
						}else if(ormsForm.txt_ed_am.value!=""){
							ormsForm.ed_am.value = ormsForm.txt_ed_am.value.replace(/,/gi,"") * 10000;
						}
						mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
						break;
					case "down2excel":
						var excel_params = {FileName:"G/L 모니터링 계정.xlsx", Merge:'1', DownCols:'6|7|9|10|11|12|13|14|15|16|17|18|19'}
						mySheet.Down2Excel(excel_params);
	
						break;
				}
			}
	
			
			function mySheet_OnSearchEnd(code, message) {
	
				if(code != 0) {
					alert("조회 중에 오류가 발생하였습니다..");
				}else{
					mySheet.SetColEditable("acg_prc_dt",0);
					mySheet.SetColEditable("brnm",0);
					mySheet.SetColEditable("crc_can_dsc",0);
					mySheet.SetColEditable("rvpy_dsc",0);
					mySheet.SetColEditable("acc_sbjnm",0);
					mySheet.SetColEditable("lss_acg_accc",0);
					mySheet.SetColEditable("tr_cntn",0);
					mySheet.SetColEditable("am",0);
					mySheet.SetColEditable("lss_rg_yn",0);
					mySheet.SetColEditable("lss_rg_rqr_dt",0);
					mySheet.SetColEditable("x_rsnctt",0);
					
					for(var i = mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
						if(mySheet.GetCellValue(i, "lss_rg_yn")=="Y"){		//사건등록여부Y일때 처리상태변경불가능처리
							mySheet.SetCellEditable(i, "lss_rg_stsc", 0); 
						}
						if(mySheet.GetCellValue(i, "lss_rg_stsc")=="02"){			//처리상태 등록불필요시 상태변경불가능, 등록불필요사유 입력가능 처리
							mySheet.SetCellEditable(i, "lss_rg_stsc", 0); 
							mySheet.SetCellEditable(i, "x_rsnctt", 1); 
						}
					}

				}
			}
			
			
			function setXrsnctt(){
				if(mySheet.RowCount()>0){
					for(var i = mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
						if(mySheet.GetCellValue(i, "ischeck")=="1"){
							mySheet.SetCellValue(i, "lss_rg_stsc", "02");
							mySheet.SetCellEditable(i, "x_rsnctt",1);
							mySheet.SetCellValue(i, "x_rsnctt", $("#all_x_rsnctt").val());
						}
					}
				}else{
					alert("사유를 입력할 조회결과가 없습니다.");
					$("#all_x_rsnctt option:eq(0)").prop("selected",true);
					return;
				}
				
// 				mySheet.DoSave("<%=System.getProperty("contextpath")%>/comMain.do?method=Main&commkind=los&process_id=ORLS011704&all_x_rsnctt="+$("#all_x_rsnctt").val()+"&lss_rg_stsc=03");
				$("#all_x_rsnctt option:eq(0)").prop("selected",true);
			}
			
			function regX(){
				for(var i = mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
					if(mySheet.GetCellValue(i, "ischeck")=="1"){
						if(mySheet.GetCellValue(i, "lss_rg_stsc")=="01"){				//이미등록된 사건 선택시 경고
							alert("등록된 사건이 선택되었습니다.");
							mySheet.SetCellValue(i, "ischeck","0");
							return;
						}
						mySheet.SetCellValue(i, "lss_rg_stsc", "02");
						mySheet.SetCellEditable(i, "x_rsnctt",1);
						mySheet.SelectCell(i, "x_rsnctt", 1, "");
					}
				}
			}
			
			function save(){
				var com = true;
				for(var i = mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
					if(mySheet.GetCellValue(i, "ischeck")=="1"){	//수정
						if(mySheet.GetCellValue(i, "lss_rg_stsc")=="02"){	//등록불필요
							if(mySheet.GetCellValue(i, "x_rsnctt").length < 1){
								alert("사유를 입력해주세요");
								mySheet.SelectCell(i, "x_rsnctt", 1, "");
								com = false;
								return;
							}
							if(mySheet.GetCellValue(i, "x_rsnctt").length < 20 || mySheet.GetCellValue(i, "x_rsnctt").length > 200){
								alert("사유는 20자 이상, 200자 이하로 입력해주세요 (현재 "+mySheet.GetCellValue(i, "x_rsnctt").length+"자)");
								mySheet.SelectCell(i, "x_rsnctt", 1, "");
								com = false;
								return;
							}
						}
						if(mySheet.GetCellValue(i, "lss_prc_sts_yn")=="Y"){
							alert("이미 등록 완료된 계정입니다.");
							com = false;
							return;
						}
					}	
				}
				if(com){
					mySheet.DoSave("<%=System.getProperty("contextpath")%>/comMain.do?method=Main&commkind=los&process_id=ORLS011803&role_id=nml");
				}
				
			}

			
			function regLss(){
				var reg_ready = true;
				var html = "";
				var cnt = 0;
				for(var i = mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
					if(mySheet.GetCellValue(i, "ischeck")=="1"){
						mySheet.SetCellValue(i, "lss_rg_stsc", "01");
						mySheet.SetCellValue(i, "x_rsnctt", "");
					}
				}
				for(var i = mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
					if(mySheet.GetCellValue(i, "ischeck")=="1"){
						if(mySheet.GetCellValue(i, "status")=="U"&&mySheet.GetCellValue(i, "lss_rg_stsc")=="01"){
							alert("이미 등록된 사건이 있습니다.");
							reg_ready = false;
							return;
						}
						if(mySheet.GetCellValue(i, "acc_dsc")==""){
							alert("금액종류를 입력해주세요");
							mySheet.SelectCell(i, "acc_dsc", 1, "");
							reg_ready = false;
							return;
						}
						html += "<input type='hidden' id='acc_sqno' 	name='acc_sqno' 	value='"+mySheet.GetCellValue(i, "acc_sqno")+"'>";					//계정일련번호
						html += "<input type='hidden' id='tr_sqno' 		name='tr_sqno' 		value='"+mySheet.GetCellValue(i, "tr_sqno")+"'>";					//거래일련번호
						html += "<input type='hidden' id='lss_acg_accc' name='lss_acg_accc' value='"+mySheet.GetCellValue(i, "lss_acg_accc")+"'>";				//손실회계계정코드
						html += "<input type='hidden' id='crc_can_dsc' 	name='crc_can_dsc' 	value='"+mySheet.GetCellValue(i, "crc_can_dsc")+"'>";				//거래구분
						html += "<input type='hidden' id='acg_prc_dt' 	name='acg_prc_dt' 	value='"+mySheet.GetCellValue(i, "acg_prc_dt")+"'>";				//회계처리일자
						html += "<input type='hidden' id='am' 			name='am' 			value='"+mySheet.GetCellValue(i, "am")+"'>";						//금액
						html += "<input type='hidden' id='tr_cntn' 		name='tr_cntn' 		value='"+mySheet.GetCellValue(i, "tr_cntn")+"'>";					//거래내용
						html += "<input type='hidden' id='rvpy_dsc' 	name='rvpy_dsc' 	value='"+mySheet.GetCellValue(i, "rvpy_dsc")+"'>";					//차대
						html += "<input type='hidden' id='acc_brc' 		name='acc_brc' 		value='"+mySheet.GetCellValue(i, "brc")+"'>";						//부서코드
						html += "<input type='hidden' id='ocu_brc' 		name='ocu_brc' 		value='"+mySheet.GetCellValue(i, "brc")+"'>";						//부서코드
						html += "<input type='hidden' id='acc_dsc' 		name='acc_dsc' 		value='"+mySheet.GetCellValue(i, "acc_dsc")+"'>";					//금액종류
						
						cnt++;
					}
				}
				if(cnt==0){
					alert("등록할 계정을 선택해주세요");
					req_ready = false
					return;
				}
				
				if(reg_ready){
					$("form[name=ormsForm] [id=register]").html(html);
					showLoadingWs();
					$("#winLossAdd").show();
					var f = document.ormsForm;
					f.method.value="Main";
			        f.commkind.value="los";
			        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
			        f.process_id.value="ORLS010301";
					f.target = "ifrLossAdd";
					f.submit();
				}
			}
			
			

			function mySheet_OnSaveEnd(code, msg) {
			    if(code >= 0) {
			        alert("처리완료");  // 저장 성공 메시지
			        doAction("search");      
			    } else {
			        alert("저장실패"); // 저장 실패 메시지
			    }
			}
			function setDtKnd(){
				if($("#dt_knd").val()==""){
					$("#st_dt").val("");
					$("#txt_st_dt").val("");
					$("#ed_dt").val("");
					$("#txt_ed_dt").val("");
					document.getElementById('txt_st_dt_btn').disabled = true;
					document.getElementById('txt_ed_dt_btn').disabled = true;
				}else{
					document.getElementById('txt_st_dt_btn').disabled = false;
					document.getElementById('txt_ed_dt_btn').disabled = false;
				}
			}
			
	</script>
		
	</head>
	<body class="">
			<div class="container">
				<%@ include file="../comm/header.jsp" %>
				<div class="content">
				<form name="ormsForm">
					<input type="hidden" id="path" name="path" />
					<input type="hidden" id="process_id" name="process_id" />
					<input type="hidden" id="commkind" name="commkind" />
					<input type="hidden" id="method" name="method" />
<!--				<input type="hidden" id="lss_acg_accc" name="lss_acg_accc" />
					<input type="hidden" id="brc" name="brc" />
 					<input type="hidden" id="acc_sqno" name="acc_sqno" />
					<input type="hidden" id="rvpy_dsc" name="rvpy_dsc" />
					<input type="hidden" id="crc_can_dsc" name="crc_can_dsc" />
					<input type="hidden" id="acc_dsc" name="acc_dsc" />
					<input type="hidden" id="acg_prc_dt" name="acg_prc_dt" />  
					<input type="hidden" id="am" name="am" />
					<input type="hidden" id="tr_cntn" name="tr_cntn" />
					<input type="hidden" id="ocu_brc" name="ocu_brc" value="" />-->
					
					<input type="hidden" id="x_rsnctt" name="x_rsnctt" />
					<input type="hidden" id="role_id" name="role_id" value="nml" />		<!-- 계정등록시 권한 -->
					<input type="hidden" id="reg_brc" name="reg_brc" value="" />    <!-- 등록시 설정되는 brc -->
					<input type="hidden" id="reg_brnm" name="reg_brnm" value="" />    <!-- 등록시 설정되는 brc -->
					
					<div id="register"></div>
					<!-- 조회 -->
					<div class="box box-search">
						<div class="box-body">
							<div class="wrap-search">
								<table>
									<tbody>
										<tr>
											<th>사건관리법인</th>
											<td>
												<div class="select w120">
													<select class="form-control w100p" id="grp_org_c" name="grp_org_c" disabled>
														<option value="">전체</option>
<%
		for(int i=0;i<vGrpList.size();i++){
			HashMap hMap = (HashMap)vGrpList.get(i);
			if(grp_org_c.equals((String)hMap.get("grp_org_c"))){
%>
														<option value="<%=(String)hMap.get("grp_org_c")%>" selected><%=(String)hMap.get("grp_orgnm")%></option>
<%
			}else{
%>
														<option value="<%=(String)hMap.get("grp_org_c")%>"><%=(String)hMap.get("grp_orgnm")%></option>
<%				
			}
		}
%>
													</select>
												</div>
											</td>
											<th scope="row">계정과목</th>
											<td>
												<span class="select">
													<select class="form-control w150" id="lss_acg_accc" name="lss_acg_accc" >
													<option value="">전체</option>
	<%
		for(int i=0;i<vLssAcgAcccLst.size();i++){
			HashMap hMap = (HashMap)vLssAcgAcccLst.get(i);
	%>
													<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
	<%
		}
	%>
													</select>
												</span>
											</td>
											<th scope="row">일자</th>
											<td colspan="3">
												<div class="form-inline">
													<span class="select ib w100">
														<select class="form-control w100p" id="dt_knd" name="dt_knd" onchange="setDtKnd()">
															<option value="">전체</option>
															<option value="ac" selected>회계처리일자</option>
															<option value="rq">등록요청일</option>
														</select>
													</span>
													<span class="w140">
														<input type="hidden" id="st_dt" name="st_dt" value="<%=st_dt %>">
														<input type="text" id="txt_st_dt" name="txt_st_dt" class="form-control w70p fl" value="<%=txt_st_dt %>" disabled/>
															<button type="button" class="btn btn-default ico fl" id="txt_st_dt_btn" name="txt_st_dt_btn" onclick="showCalendar('yyyy-MM-dd','txt_st_dt');">
															<i class="fa fa-calendar"></i>
														</button>
													</span>
													<span> ~ </span> 
													<span class="w140">
														<input type="hidden" id="ed_dt" name="ed_dt">
														<input type="text" id="txt_ed_dt" name="txt_ed_dt" class="form-control w70p fl" disabled/>
															<button type="button" class="btn btn-default ico fl" id="txt_ed_dt_btn" name="txt_ed_dt_btn" onclick="showCalendar('yyyy-MM-dd','txt_ed_dt');">
															<i class="fa fa-calendar"></i>
														</button>
													</span>
												</div>
											</td>
										</tr>
										<tr>
											<th scope="row">부서(영업점)</th>
											<td>
												<div class="input-group">
												  <input type="text" class="form-control" id="brnm" name="brnm" value="<%=(String)hMap2.get("brnm")%>" disabled>
												  <input type="hidden" id="brc" name="brc" value="<%=(String)hMap2.get("brc")%>" />
												</div><!-- /input-group -->
											</td>
											<th scope="row" style="display:none">사건등록요청여부</th>
											<td style="display:none">
												<span class="select">
													<select class="form-control w150" id="lss_rg_rqr_stsc" name="lss_rg_rqr_stsc" >
													<option value="">선택</option>
													<option value="00">-</option>
													<option value="01" selected>등록요청</option>
													<option value="02">등록불필요</option>
													</select>
												</span>
											</td>											
											<th scope="row">금액</th>
											<td colspan="5" class="form-inline">
												<div class="form-group">
													<div class="input-group">
														<input type="hidden" id="st_am" name="st_am"/> 
														<input type="text"  class="form-control text-right"  style="width:80px;" id="txt_st_am" name="txt_st_am"/> 
														<span class="input-group-addon">만원 </span>
													</div>
												</div>
												<span class="input-group-addon ib mr10"> ~ </span>
												<div class="input-group">
													<input type="hidden" id="ed_am" name="ed_am" />
													<input type="text" class="form-control text-right" style="width:80px;" id="txt_ed_am" name="txt_ed_am" />
													<span class="input-group-addon">만원 </span>
												</div>
											</td>
										</tr>
										<tr>
											<th scope="row"  style="display: none;">정렬기준</th>
											<td  style="display: none;">
												<span class="select">
													<select class="form-control w150" id="sort_sbj" name="sort_sbj" >
													<option value="ACG_PRC_DT">회계처리일자</option>
													<option value="ACC_SBJNM">계정과목명</option>
													<option value="LSS_ACG_ACCC">손실회계계정코드</option>
													<option value="RVPY_DSC">차대</option>
													<option value="ACC_AM">금액</option>
													<option value="CRC_CAN_DSC">정정취소구분</option>
													</select>
												</span>
											</td>											
											<th scope="row"  style="display: none;">정렬순서</th>
											<td  style="display: none;">
												<span class="select">
													<select class="form-control w150" id="sort" name="sort" >
													<option value="ASC">오름차순</option>
													<option value="DESC">내림차순</option>
													</select>
												</span>
											</td>											
											<th scope="row">사건등록여부</th>
											<td>
												<span class="select">
													<select class="form-control w150" id="lss_rg_stsc" name="lss_rg_stsc" >
													<option value="">전체</option>
													<option value="01">등록완료</option>
													<option value="02">등록불필요</option>
													</select>
												</span>
											</td>
											<th scope="row">처리상태</th>
											<td>
												<span class="select">
													<select class="form-control w150" id="lss_prc_sts_yn" name="lss_prc_sts_yn" >
													<option value="">전체</option>
													<option value="Y">완료</option>
													<option value="N">미완료</option>
													</select>
												</span>
											</td>
										</tr>
									</tbody>
								</table>
							</div><!-- .box-search -->
						</div><!-- .box-body //-->
						<div class="box-footer">
							<button type="button" class="btn btn-primary search" onclick="javascript:doAction('search');">조회</button>
						</div>
					</div><!-- .box-search //-->
				</form>	
				
				
					<!-- 조회 //-->
					<div class="box box-grid">
						<div class="box-header">
							<div class="area-tool">
								<div class="btn-group" style="display: none;">
									<span class="select">
										<select class="form-control w200" id="all_x_rsnctt" name="all_x_rsnctt" onchange="setXrsnctt()" >
										<option value="">등록불필요사유일괄입력</option>
				<%
						for(int i=0;i<vXRsnCttLst.size();i++){
							HashMap hp = (HashMap)vXRsnCttLst.get(i);
				%>
										<option value="<%=(String)hp.get("intg_cnm")%>"><%=(String)hp.get("intg_cnm")%></option>
				<%
						}
				%>
										</select>
									</span>
								</div>
								<button type="button" class="btn btn-xs btn-default" onclick="javascript:doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
							</div>
						</div>
						<!-- /.box-header -->
						<div class="box-body">
							<div class="wrap-grid scroll h400">
								<script> createIBSheet("mySheet", "100%", "100%"); </script>
							</div><!-- .wrap //-->
						</div><!-- .box-body //-->
						<div class="box-footer">
							<div class="btn-wrap right">
								<button type="button" class="btn btn-primary" onclick="regLss();">사건등록</button>
								<button type="button" class="btn btn-primary" onclick="save();">등록불필요</button>
								<button type="button" class="btn btn-default" onclick="javascript:doAction('search');">취소</button>
							</div>
						</div><!-- .box-footer //-->
					</div><!-- .box //-->
				</div><!-- .content //-->
			</div><!-- .container //-->		
	
	
	
	<!-- popup -->
	<div id="winLossAdd" class="popup modal"  style="background-color:transparent">
		<iframe name="ifrLossAdd" id="ifrLossAdd" src="about:blank" width="100%" height="100%" scrolling="no" frameborder="0" allowTransparency="true" ></iframe>
	</div>
	<%@ include file="../comm/OrgInfP.jsp" %> <!-- 부서 공통 팝업 -->
	
	<script>
		// 발생부서검색 완료
		function Org_Popup(){
			init_flag = false;
			schOrgPopup("brnm", "orgSearchEnd");
			if($("#brnm").val() == "" && init_flag){
				$("#ifrOrg").get(0).contentWindow.doAction("search");
			}
			init_flag = false;
		}
		function orgSearchEnd(brc, brnm){
			$("#brc").val(brc);
			$("#brnm").val(brnm);
			$("#winBuseo").hide();
		}
			
		$(document).ready(function(){
			
			//열기
			$(".btn-open").click( function(){
				$(".popup").show();
			});
			//닫기
			$(".btn-close").click( function(event){
				$(".popup",parent.document).hide();
				event.preventDefault();
			});
		});
			
	</script>
	</body>
</html>