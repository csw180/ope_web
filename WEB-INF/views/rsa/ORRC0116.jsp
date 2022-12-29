<%--
/*---------------------------------------------------------------------------
 Program ID   : ORRC0116.jsp
 Program name : 결과확인및재평가요청
 Description  : 화면정의서 RCSA-10
 Programer    : 박승윤
 Date created : 2022.09.15
 ---------------------------------------------------------------------------*/
--%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.shbank.orms.comm.SysDateDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
/* 
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
HashMap hMap1 = (HashMap)vLst.get(0);
 */
DynaForm form = (DynaForm)request.getAttribute("form");
/*
	rcsa_menu_dsc 
  1 : 결과확인 및 재평가 요청
  2 : 결과확인 및 결재(운영리스크 팀장)
*/

Vector vRkEvlGrdC = CommUtil.getCommonCode(request, "RK_EVL_GRD_C");
if(vRkEvlGrdC==null) vRkEvlGrdC = new Vector();

String rkEvlGrdC = "";
String rkEvlGrdNm = "";
/*리스크 평가 등급 코드*/
for(int i=0;i<vRkEvlGrdC.size();i++){
	HashMap hMap = (HashMap)vRkEvlGrdC.get(i);
	if( i > 0 ){
		rkEvlGrdC += "|";
		rkEvlGrdNm += "|";
	}
	rkEvlGrdC += (String)hMap.get("intgc");
	
	rkEvlGrdNm += (String)hMap.get("intg_cnm");
}
/*통제 평가 등급 코드*/
Vector vCtlDsgEvlC = CommUtil.getCommonCode(request, "CTL_DSG_EVL_C");
if(vCtlDsgEvlC==null) vCtlDsgEvlC = new Vector();

String rkCtlDsgEvlC = "";
String rkCtlDsgEvlNm = "";

for(int i=0;i<vCtlDsgEvlC.size();i++){
	HashMap hMap = (HashMap)vCtlDsgEvlC.get(i);
	if( i > 0 ){
		rkCtlDsgEvlC += "|";
		rkCtlDsgEvlNm += "|";
	}
	rkCtlDsgEvlC += (String)hMap.get("intgc");
	
	rkCtlDsgEvlNm += (String)hMap.get("intg_cnm");
}
/*리스크결재진행단계*/
Vector vRkEvlDczStsc = CommUtil.getCommonCode(request, "RK_EVL_DCZ_STSC");
if(vRkEvlDczStsc==null) vRkEvlDczStsc = new Vector();

String rkEvlDczStsc = "";
String rkEvlDczStnm = "";

for(int i=0;i<vRkEvlDczStsc.size();i++){
	HashMap hMap = (HashMap)vRkEvlDczStsc.get(i);
	if( i > 0 ){
		rkEvlDczStsc += "|";
		rkEvlDczStnm += "|";
	}
	rkEvlDczStsc += (String)hMap.get("intgc");
	
	rkEvlDczStnm += (String)hMap.get("intg_cnm");
}

/*잔여위험등급*/
Vector vRmnRskGrdC = CommUtil.getCommonCode(request, "RMN_RSK_GRD_C");
if(vRmnRskGrdC==null) vRmnRskGrdC = new Vector();

String rkRmnRskGrdC = "";
String rkRmnRskGrdNm = "";

for(int i=0;i<vRmnRskGrdC.size();i++){
	HashMap hMap = (HashMap)vRmnRskGrdC.get(i);
	if( i > 0 ){
		rkRmnRskGrdC += "|";
		rkRmnRskGrdNm += "|";
	}
	rkRmnRskGrdC += (String)hMap.get("intgc");
	
	rkRmnRskGrdNm += (String)hMap.get("intg_cnm");
}

String init_brc = "";
String init_brnm = "";

if( form.get("rcsa_menu_dsc").equals("3") ){
	init_brc = brc;
	init_brnm = brnm;
}

%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../comm/library.jsp" %>
	<script src="<%=System.getProperty("contextpath")%>/js/OrgInfP.js"></script>
	<script language="javascript">
	
	$(document).ready(function(){
		// ibsheet 초기화
		initIBSheet();
		doSearch();
	});
	
	/*Sheet 기본 설정 */
	function initIBSheet() {
		//시트 초기화
		mySheet.Reset();
		
		var initData = {};
		
		initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; 
		initData.Cols = [
						{Header:"선택",Type:"CheckBox",Width:50,Align:"Left",SaveName:"ischeck",MinWidth:50,Edit:1},				
		    			{Header:"그룹내기관코드",Type:"Text",Width:0,Align:"Center",SaveName:"grp_org_c",MinWidth:60, Hidden:true},
		    			{Header:"사무소코드",Type:"Text",Width:0,Align:"Center",SaveName:"brc",MinWidth:60, Hidden:true},
		    			{Header:"리스크사례ID",Type:"Text",Width:0,Align:"Center",SaveName:"rkp_id",MinWidth:60,Edit:0},
						{Header:"리스크평가기준년월",Type:"Text",Width:0,Align:"Center",SaveName:"bas_ym",MinWidth:60, Hidden:true},
						{Header:"평가부서",Type:"Text",Width:100,Align:"Center",SaveName:"dept_brnm",MinWidth:100,Edit:0},
						{Header:"팀",Type:"Text",Width:100,Align:"Center",SaveName:"brnm",MinWidth:100,Edit:0},
						{Header:"업무 프로세스\nLV1",Type:"Text",Width:100,Align:"Left",SaveName:"prssnm1",MinWidth:100,Edit:0},
						{Header:"업무 프로세스\nLV2",Type:"Text",Width:100,Align:"Left",SaveName:"prssnm2",MinWidth:100,Edit:0},
						{Header:"업무 프로세스\nLV3",Type:"Text",Width:100,Align:"Left",SaveName:"prssnm3",MinWidth:100,Edit:0},
						{Header:"업무 프로세스\nLV4",Type:"Text",Width:100,Align:"Left",SaveName:"prssnm4",MinWidth:100,Edit:0},
		    			{Header:"리스크 사례",Type:"Text",Width:100,Align:"Left",SaveName:"rk_isc_cntn",MinWidth:60,Edit:0},
						{Header:"통제활동",Type:"Text",Width:300,Align:"Left",SaveName:"cp_cntn",MinWidth:200,Edit:0},
						{Header:"위험\n등급",Type:"Combo",Width:80,Align:"Center",SaveName:"rk_evl_grd_c",MinWidth:60,ComboText:"<%=rkEvlGrdNm%>", ComboCode:"<%=rkEvlGrdC%>",Edit:0},
						{Header:"통제\n등급",Type:"Combo",Width:80,Align:"Center",SaveName:"ctev_grd_c",MinWidth:60,ComboText:"<%=rkCtlDsgEvlNm%>", ComboCode:"<%=rkCtlDsgEvlC%>",Edit:0},
						{Header:"잔여위험\n등급",Type:"Combo",Width:80,Align:"Center",SaveName:"rmn_rsk_grd_c",MinWidth:60,ComboText:"<%=rkRmnRskGrdNm%>", ComboCode:"<%=rkRmnRskGrdC%>",Edit:0},
						{Header:"평가\n상태",Type:"Text",Width:0,Align:"Center",SaveName:"evl_stsc",MinWidth:60,Edit:0},
						{Header:"결재\n진행단계",Type:"Combo",Width:80,Align:"Center",SaveName:"rk_evl_dcz_stsc",MinWidth:60,ComboText:"<%=rkEvlDczStnm%>", ComboCode:"<%=rkEvlDczStsc%>",Edit:0},
						{Header:"평가자개인번호",Type:"Text",Width:0,Align:"Center",SaveName:"vlr_eno",MinWidth:60, Hidden:true},
						{Header:"평가자",Type:"Text",Width:100,Align:"Center",SaveName:"vlr_nm",MinWidth:100,Edit:0,MultiLineText:1},
						{Header:"재평가\n대상여부",Type:"Text",Width:100,Align:"Center",SaveName:"reevl_yn",MinWidth:100,Edit:0},
						{Header:"결재요청\n여부",Type:"Text",Width:100,Align:"Center",SaveName:"dcz_rq_yn",MinWidth:100,Edit:0, Hidden:true},
						{Header:"결재 완료\n여부",Type:"Text",Width:100,Align:"Center",SaveName:"dcz_yn",MinWidth:100,Edit:0, Hidden:true},				
		    			{Header:"반송사유",Type:"Text",Width:60,Align:"Left",SaveName:"rtn_cntn",MinWidth:100,Edit:0, Hidden:true}				
						
		];

		IBS_InitSheet(mySheet,initData);
		
		//필터표시
		//mySheet.ShowFilterRow();  
		
		//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
		//mySheet.SetCountPosition(0);
		
		// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
		// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		mySheet.SetSelectionMode(4);
		
		mySheet.FitColWidth();
		//마우스 우측 버튼 메뉴 설정
		//setRMouseMenu(mySheet);
		
//		doAction('search');

		
	}
	
	var row = "";
	var url = "<%=System.getProperty("contextpath")%>/comMain.do";
	
	/*Sheet 각종 처리*/
	function doAction(sAction) {

		switch(sAction) {
			case "search":  //데이터 조회

				var opt = {};
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("rsa");
				$("form[name=ormsForm] [name=process_id]").val("ORRC011603");

				mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
				break;
				
			case "toevl":  //재평가요청
				
				$("#reevl_yn_chk").val("Y");
				$("#dcz_dc").val("02");
				doSave();
				break;
			case "save":  //
				
				$("#reevl_yn_chk").val("");
				$("#dcz_dc").val("15");
				doSave();
				break;
			case "sub":  //
				
				$("#reevl_yn_chk").val("");
				$("#dcz_dc").val("14");
				doSave();
				break;
			case "down2excel":
				
				setExcelFileName("RCSA평가결과확인.xlsx");
				setExcelDownCols("5|6|8|10|12|14|15|16|17|18|19|21|22");
				mySheet.Down2Excel(excel_params);

				break;

		}
	}
	
	
	function doSearch() {
		var f = document.ormsForm;
		
		WP.clearParameters();
		WP.setParameter("method", "Main");
		WP.setParameter("commkind", "rsa");
		WP.setParameter("process_id", "ORRC011602");
		WP.setForm(f);
		
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		var inputData = WP.getParams();
		showLoadingWs(); // 프로그래스바 활성화
		
		
		WP.load(url, inputData,{
			success: function(result){

			  if(result!='undefined' && result.rtnCode=="0") 
			  {
				  var rList = result.DATA;
				if (rList.length > 0) {
				  $("#bas_ym").val(rList[0].bas_ym);
				  $("#bas_ym_nm").text(rList[0].bas_ym_nm);
				  $("#evl_date").text(rList[0].evl_date);
				  $("#cpl_rat").text(zeroPadding(rList[0].evl_rate));
				}
				  
			  } else if(result!='undefined' && result.rtnCode!="0"){
					alert(result.rtnMsg);
				}
			  
			},
			  
			complete: function(statusText,status) {
				removeLoadingWs();
			},
			  
			error: function(rtnMsg){
				alert(JSON.stringify(rtnMsg));
				
			}
		});
		removeLoadingWs();
		
		

	}

	
	function doSave() {
		
		
		
		//if(!confirm("결재요청 진행하시겠습니까?")) return;

		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		mySheet.DoSave(url, { Param : "method=Main&commkind=rsa&process_id=ORRC011604&dcz_dc="+$("#dcz_dc").val()+"&reevl_yn_chk="+$("#reevl_yn_chk").val(), Col : 0 });
	}

	function mySheet_OnSearchEnd(code, message) {

	    if(code == 0) {
	    	mySheet.FitColWidth();
	        //조회 후 작업 수행
	
		} else {
	
		        alert("조회 중에 오류가 발생하였습니다..");
		        
	
		}

	}

	function mySheet_OnSaveEnd(code, msg) {
	    if(code >= 0) {
	    	
	    	doAction('search');
	    	alert("저장 하였습니다.");      

	    } else {

	        alert(msg); // 저장 실패 메시지

	    }
	}
	
	</script>
	</head>
	<body class="">
		<!-- iframe 영역 -->
		<div class="container">
			<%@ include file="../comm/header.jsp" %>
			
			<div class="content">
				<!-- .search-area 검색영역 -->
				<form name="ormsForm">
					<input type="hidden" id="path" name="path" />
					<input type="hidden" id="process_id" name="process_id" />
					<input type="hidden" id="commkind" name="commkind" />
					<input type="hidden" id="method" name="method" />
					<input type="hidden" id="rcsa_menu_dsc" name="rcsa_menu_dsc" value=<%=form.get("rcsa_menu_dsc")%> />				
					<input type="hidden" id="dcz_dc" name="dcz_dc" />
					<input type="hidden" id="reevl_yn_chk" name="reevl_yn_chk" />
					<input type="hidden" id="table_name" name="table_name" value="TB_OR_RH_EVL_DCZ"/>
					<input type="hidden" id="dcz_code" name="stsc_column_name" value="RK_EVL_DCZ_STSC"/>
					<input type="hidden" id="rpst_id_column" name="rpst_id_column" value="OPRK_RKP_ID"/>
					<input type="hidden" id="rpst_id" name="rpst_id" value=""/>
					<input type="hidden" id="bas_pd_column" name="bas_pd_column" value="BAS_YM"/>
					<input type="hidden" id="bas_pd" name="bas_pd" value=""/>
					<input type="hidden" id="dcz_objr_emp_auth" name="dcz_objr_emp_auth" value=""/>
					<input type="hidden" id="sch_rtn_cntn" name="sch_rtn_cntn" value=""/>
					<input type="hidden" id="dcz_objr_eno" name="dcz_objr_eno" value=""/>
					<input type="hidden" id="dcz_rmk_c" name="dcz_rmk_c" value=""/>
					<input type="hidden" id="brc_yn" name="brc_yn" value="Y"/>
					<input type="hidden" id="dcz_brc" name="dcz_brc" value="<%=brc%>"/>
				<!-- .search-area 검색영역 -->
				<div class="box box-search case01">
					<div class="box-body">
						<div class="wrap-search">
							<table>

								<tbody>
									<tr>
										<th scope="row"><label for="input03" class="control-label">조직</label></th>
										<td>
											<div class="input-group w150">
												<input type="hidden" id="brc" name="brc" value="<%=init_brc%>">
												<input type="text" class="form-control" id="brnm" name="brnm" placeholder="전체" value="<%=init_brnm%>" readonly/>
												<span class="input-group-btn">
												<%
if( !form.get("rcsa_menu_dsc").equals("3") ){
 %>		
												<button class="btn btn-default ico search" type="button"  onclick="org_popup();"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
				<%} %>
											  </span>
												</div>
										</td>
										<th scope="row">업무 프로세스</th>
										<td>
											<div class="input-group w150">
											  <input type="hidden" id="bsn_prss_c" name="bsn_prss_c">
											  <input class="form-control" type="text" id="bsn_prss_nm" name="bsn_prss_nm">
											  <span class="input-group-btn">
												<button class="btn btn-default ico search" type="button"  onclick="prss_popup();"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
											  </span>
											</div>
										</td>
										<th scope="row">평가자</th>
										<td>
											<div class="input-group w100">
											  <input type="hidden" id="vlr_eno" name="vlr_eno">
											  <input class="form-control" type="text" id="vlr_ennm" name="vlr_ennm">
											  <span class="input-group-btn">
												<button class="btn btn-default ico search" type="button"  onclick="eno_popup();"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
											  </span>
											</div>
										</td>
										<th scope="row">사건유형</th>
										<td>
											<div class="input-group w100">
												<input type="hidden" id="hpn_tpc" name="hpn_tpc">
												<input type="text" class="form-control w100 fl" id="hpn_tpc_nm" name="hpn_tpc_nm" />
											  <span class="input-group-btn">
												<button class="btn btn-default ico search" type="button"  onclick="hpn_popup();"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
											  </span>
											</div>
										</td>
										<th scope="row">영향유형</th>
										<td>
											<div class="input-group w100">
											<input type="hidden" id="ifn_tpc" name=ifn_tpc>
											<input type="text" class="form-control w100 fl" id="ifn_tpc_nm" name="ifn_tpc_nm" />
											  <span class="input-group-btn">
												<button class="btn btn-default ico search" type="button"  onclick="ifn_popup();"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
											  </span>
											</div>
										</td>
										</tr>
									<tr>
										<th scope="row">영향평가(재무)</th>
										<td>
											<span class="select fl">
												<select class="form-control" id="ifn_evl_c" name="ifn_evl_c" >
													<option value="">전체</option>
													<option value="1">1등급</option>
													<option value="2">2등급</option>
													<option value="3">3등급</option>
													<option value="4">4등급</option>
													<option value="5">5등급</option>
												</select>
											</span>
										</td>
										<th scope="row">영향평가(비재무)</th>
										<td>
											<span class="select fl">
												<select class="form-control" id="nifn_evl_c" name="nifn_evl_c" >
													<option value="">전체</option>
													<option value="1">1등급</option>
													<option value="2">2등급</option>
													<option value="3">3등급</option>
													<option value="4">4등급</option>
													<option value="5">5등급</option>
												</select>
											</span>
										</td>
										<th scope="row">빈도평가</th>
										<td>
											<span class="select fl">
												<select class="form-control" id="frq_evl_c" name="frq_evl_c" >
													<option value="">전체</option>
													<option value="1">1등급</option>
													<option value="2">2등급</option>
													<option value="3">3등급</option>
													<option value="4">4등급</option>
													<option value="5">5등급</option>
												</select>
											</span>
										</td>
										<th scope="row">통제평가</th>
										<td>
											<span class="select fl">
												<select class="form-control" id="ctev_grd_c" name="ctev_grd_c" >
													<option value="">전체</option>
													<option value="1">상</option>
													<option value="2">중</option>
													<option value="3">하</option>
												</select>
											</span>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div><!-- .box-body //-->
					
					<div class="box-footer">
						<button type="button" class="btn btn-primary search" onclick="javascript:doAction('search');">조회</button>
					</div>
				</div><!-- .search-area //-->
				

				<div class="box box-grid mt20">
					<div class="box-header">
						<div class="ib">
						<span class="txt txt-sm ca">평가기준년월 </span>
						<strong id="bas_ym_nm" class="cs">2021-00차</strong> 
						<span class="txt txt-sm ca"> / 평가기간 </span>
						<strong id="evl_date" class="cs">2021-00-00 ~ 2021-00-00</strong>
						</div>
						<div class="area-tool">
							
							<button type="button" class="btn btn-xs btn-default" onclick="javascript:doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
						</div>
					</div>
					<div class="box-body">
						<div class="wrap-grid h450">
							<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%"); </script>
						</div>
					</div>
					<div class="box-footer">
						<div class="btn-wrap right">
							<!-- <span class="txt txt-sm ca" ><strong style="color:red;" >* 전 부서의 모든 평가대상 리스크가 평가완료 상태일 경우에만 일괄평가확인이 진행됩니다.</strong></span>&nbsp;&nbsp;&nbsp; -->
<%
if( form.get("rcsa_menu_dsc").equals("1") ){ //리스크담당자
 %>	
							<button type="button" class="btn btn-xs btn-default" onclick="javascript:doAction('toevl');">재평가요청</button>
							<button type="button" class="btn btn-primary" onclick="javascript:doAction('sub');">결재요청</button>
<%
}
else
if( form.get("rcsa_menu_dsc").equals("2") ){ //부서장
%>
							<button type="button" class="btn btn-primary" onclick="javascript:doAction('save');">결재</button>
<%
}
else
if( form.get("rcsa_menu_dsc").equals("3") ){ //부서담당자
%>
							<button type="button" class="btn btn-xs btn-default" onclick="javascript:doAction('toevl');">재평가요청</button>
<%} %>
						</div>
					</div>
				</div>
				
				</form>
				
			</div><!-- .content //-->
		</div><!-- .container //-->
			<!-- popup //-->
<%@ include file="../comm/OrgInfP.jsp" %> <!-- 부서 공통 팝업 -->
<%@ include file="../comm/PrssInfP.jsp" %> <!-- 업무프로세스 공통 팝업 -->
<%@ include file="../comm/HpnInfP.jsp" %> <!-- 사건유형 공통 팝업 -->

<%@ include file="../comm/IfnInfP.jsp" %> <!-- 영향유형 공통 팝업 -->
<%@ include file="../comm/EmpInfP.jsp" %> <!-- 직원 공통 팝업 -->
		<!-- popup //-->
	<script>
	
	var init_flag = false;
	function org_popup(){
		schOrgPopup("brnm", "orgSearchEnd");
		if($("#brnm").val() == "" && init_flag){
			$("#ifrOrg").get(0).contentWindow.doAction("search");
		}
		init_flag = false;
	}
	
	// 부서검색 완료
	function orgSearchEnd(brc, brnm){
		if(brc=="") init_flag = true;
		
		$("#brc").val(brc);
		$("#brnm").val(brnm);
		$("#winBuseo").hide("block");
		//doAction('search');
	}
	
	function eno_popup(){
		$("#vlr_eno").val("");
		$("#vlr_ennm").val("");
		if(ifrEmp.cur_click!=null) ifrEmp.cur_click();
		schEmpPopup(null,'empSearchEnd');
	}

	// 직원검색 완료
	function empSearchEnd(eno, ennm){
		$("#vlr_eno").val(eno);
		$("#vlr_ennm").val(ennm);
		
		$("#winEmp").hide("block");
		//doAction('search');
	}
	
	// 업무프로세스검색 완료
	var PRSS4_ONLY = false; 
	var CUR_BSN_PRSS_C = "";
	
	function prss_popup(){
		//$("#bsn_prss_c").val("");
		//$("#bsn_prss_nm").val("");
		CUR_BSN_PRSS_C = $("#bsn_prss_c").val();
		if(ifrPrss.cur_click!=null) ifrPrss.cur_click();
		schPrssPopup();
	}
	

	function prssSearchEnd(bsn_prss_c, bsn_prsnm
							, bsn_prss_c_lv1, bsn_prsnm_lv1
							, bsn_prss_c_lv2, bsn_prsnm_lv2
							, bsn_prss_c_lv3, bsn_prsnm_lv3
							, biz_trry_c_lv1, biz_trry_cnm_lv1
							, biz_trry_c_lv2, biz_trry_cnm_lv2){

		if (bsn_prss_c.substr(2,2) == "00")
			bsn_prss_c = bsn_prss_c.substr(0,2);
		else if (bsn_prss_c.substr(4,2) == "00")
			bsn_prss_c = bsn_prss_c.substr(0,4);
		else if (bsn_prss_c.substr(6,2) == "00")
			bsn_prss_c = bsn_prss_c.substr(0,6);
			
			
		$("#bsn_prss_c").val(bsn_prss_c);
		$("#bsn_prss_nm").val(bsn_prsnm);
		
		$("#winPrss").hide();
	}

	// 손실사건유형검색 완료
	var HPN3_ONLY = false; 
	var CUR_HPN_TPC = "";
	
	function hpn_popup(){
		CUR_HPN_TPC = $("#hpn_tpc").val();
		if(ifrHpn.cur_click!=null) ifrHpn.cur_click();
		schHpnPopup();
	}
	
	function hpnSearchEnd(hpn_tpc, hpn_tpnm
						, hpn_tpc_lv1, hpn_tpnm_lv1
						, hpn_tpc_lv2, hpn_tpnm_lv2){
		
		if (hpn_tpc.substr(2,2) == "00")
			hpn_tpc = hpn_tpc.substr(0,2);
		else if (hpn_tpc.substr(4,2) == "00")
			hpn_tpc = hpn_tpc.substr(0,4);
		
		$("#hpn_tpc").val(hpn_tpc);
		$("#hpn_tpc_nm").val(hpn_tpnm);
		
		$("#winHpn").hide();
		//doAction('search');
	}
	
	// 영향유형검색 완료
	var IFN2_ONLY = false; 
	var CUR_IFN_TPC = "";
	
	function ifn_popup(){
		CUR_IFN_TPC = $("#ifn_tpc").val();
		schIfnPopup();
	}
	
	function ifnSearchEnd(ifn_tpc, ifn_tpnm
						, ifn_tpc_lv1, ifn_tpnm_lv1
						, ifn_tpc_lv2, ifn_tpnm_lv2){
		
		if (ifn_tpc.substr(2,2) == "00")
			ifn_tpc = ifn_tpc.substr(0,2);
		
		$("#ifn_tpc").val(ifn_tpc);
		$("#ifn_tpc_nm").val(ifn_tpnm);
		
		$("#winIfn").hide();
		//doAction('search');
	}
	
	$(document).ready(function(){
		//열기
		$(".btn-open").click( function(){
			$(".popup").addClass("block");
		});
		//닫기
		$(".btn-close").click( function(event){
			$(".popup").removeClass("block");
			 doAction("search");
			$(".popup",parent.document).removeClass("block");
			event.preventDefault();
		});
		// dim (반투명 ) 영역 클릭시 팝업 닫기 
		$('.popup >.dim').click(function () {  
			//$(".popup").removeClass("block");
		});
	});
		
	function closePop(){
		$("#winNonEvl").removeClass("block");
		$("#winRskEvl").removeClass("block");
		$("#winBuseo").removeClass("block");
	}
	// 부점검색 완료
	function buseoSearchEnd(kbr_nm, new_br_cd){
		$("#kbr_nm").val(kbr_nm);
		$("#sch_new_br_cd").val(new_br_cd);
		closeBuseo();
		//doAction('search');
	}
		</script>
	</body>
</html>