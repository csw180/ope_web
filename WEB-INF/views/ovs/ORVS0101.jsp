<%--
/*---------------------------------------------------------------------------
 Program ID   : ORVS0101.jsp
 Program name : 해외법인 보고서 관리
 Description  : 화면정의서 OVRS-0100
 Programer    : 고창호
 Date created : 2022.08.08
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%@ include file="../comm/DczP.jsp" %> <!-- 결재 공통 팝업 -->
<%
response.setHeader("Pragma", "No-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Expires", "0");

/*
OVRS_MENU_DSC
1 : ORM
2 : ORM팀장
*/
DynaForm form = (DynaForm)request.getAttribute("form");
Vector vLst1= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst1==null) vLst1 = new Vector();

Vector vOvrsDczC = CommUtil.getCommonCode(request, "OVRS_DCZ_PRG_STSC");
if(vOvrsDczC==null) vOvrsDczC = new Vector();

String OvrsDczC = "";
String OvrsDczNm = "";
/*해외보고서 결재 상태*/
for(int i=0;i<vOvrsDczC.size();i++){
	HashMap hMap = (HashMap)vOvrsDczC.get(i);
	if( i > 0 ){
		OvrsDczC += "|";
		OvrsDczNm += "|";
	}
	OvrsDczC += (String)hMap.get("intgc");
	
	OvrsDczNm += (String)hMap.get("intg_cnm");
}


%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="../comm/library.jsp" %>
	<title>해외법인 보고서 관리</title>
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

			/*mySheet*/
			initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; 
			initData.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:0};
			
			initData.Cols = [
				{Header:"선택",Type:"CheckBox",Width:50,Align:"Center",SaveName:"ischeck", MinWidth:50},
				{Header:"상태", Type:"Status",Width:50,Align:"Center",HAlign:"Center",SaveName:"status",MinWidth:40,Edit:true, Hidden:true},
				{Header:"보고년월",Type:"Number",Width:60,Align:"Center",SaveName:"bas_ym",MinWidth:60,Edit:false},
				{Header:"보고서명",Type:"Text",Width:300,Align:"Left",SaveName:"rpt_tit",MinWidth:300,Edit:false},
				{Header:"상태",Type:"Combo",Width:100,Align:"Center",SaveName:"ovrs_dcz_prg_stsc",MinWidth:100,ComboText:"<%=OvrsDczNm%>", ComboCode:"<%=OvrsDczC%>",Edit:0},
				{Header:"결재상신일",Type:"Date",Width:60,Align:"Center",SaveName:"dcz_st_dt",MinWidth:60,Edit:false},
				{Header:"결재완료일",Type:"Date",Width:60,Align:"Center",SaveName:"dcz_ed_dt",MinWidth:60,Edit:false},
				{Header:"조회/수정",Type:"Html",Width:60,Align:"Center",SaveName:"btn_rg",MinWidth:60}, 
				{Header:"결재현황",Type:"Html",Width:60,Align:"Center",SaveName:"DetailDcz",MinWidth:60 },
			
				];
			/*mySheet end*/
			
			IBS_InitSheet(mySheet,initData);
			

			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			//mySheet.SetCountPosition(3);
			
			
			
			mySheet.SetSelectionMode(4);
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			//컬럼의 너비 조정
			mySheet.FitColWidth();
		
			doAction('search');
			
		}
		
		var row = "";
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
			
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
				case "search":  //데이터 조회						
									
					var opt = {};
					
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("ovs");
					$("form[name=ormsForm] [name=process_id]").val("ORVS010102");
					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				
				case "reload":  //조회데이터 리로드
				
					mySheet.RemoveAll();
					initIBSheet();
					break;
				
				case "dcsRpsp":	//결재상신
					var f = document.ormsForm;
					
					if(mySheet.CheckedRows("ischeck") < 1)
					{
						alert("항목을 선택해주세요.");
						return;
					}
					
					//진행상태 체크 (게시완료된 기사가 있는경우 return)
					for(var i = mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
							if(mySheet.GetCellValue(i, "ischeck")=="1"&&mySheet.GetCellValue(i, "ovrs_dcz_prg_stsc")!= "13"){				//이미요청된 사건 선택시 경고
								alert("작성완료 상태가 아닌 항목이 포함되어 있습니다.");
								return;
							}
						}
					
						$("#dcz_dc").val("14"); 
						$("#dcz_objr_emp_auth").val("'009'");
						for(var i = mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
							if(mySheet.GetCellValue(i, "ischeck")=="1"){
								$("#rpst_id").val(mySheet.GetCellValue(i,"bas_ym"));
								$("#bas_pd").val(mySheet.GetCellValue(i,"bas_ym"));
								}
							}
						schDczPopup(1);


										
					break;
				
				case "dczCmp":	//결재
					var f = document.ormsForm;
					
					if(mySheet.CheckedRows("ischeck") < 1)
					{
						alert("항목을 선택해주세요.");
						return;
					}
					
					//진행상태 체크 (게시완료된 기사가 있는경우 return)
					for(var i = mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
							if(mySheet.GetCellValue(i, "ischeck")=="1"&&mySheet.GetCellValue(i, "ovrs_dcz_prg_stsc")!= "14"){				//이미요청된 사건 선택시 경고
								alert("결재상신 상태가 아닌 항목이 포함되어 있습니다.");
								return;
							}
						}
					
						$("#dcz_dc").val("15"); 
						$("#dcz_objr_emp_auth").val("'002'");
						for(var i = mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
								if(mySheet.GetCellValue(i, "ischeck")=="1"){
								$("#rpst_id").val(mySheet.GetCellValue(i,"bas_ym"));
								$("#bas_pd").val(mySheet.GetCellValue(i,"bas_ym"));
								}
							}
						schDczPopup(2);


										
					break;
				
				case "add":		//신규등록 팝업
					$("#mode").val("I");
					$("#popBas_ym").val("");
					showLoadingWs();
					//$("#ifrLossAdd").attr("src","about:blank");
					$("#winORVS0102").show();
					var f = document.ormsForm;
					f.method.value="Main";
			        f.commkind.value="ovs";
			        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
			        f.process_id.value="ORVS010201";
					f.target = "ifrORVS0102";
					f.submit();
					break;
				
							
				case "mod":		//수정 팝업
					
					$("#mode").val("U");
					showLoadingWs();
					//$("#ifrLossAdd").attr("src","about:blank");
					$("#winORVS0102").show();
					var f = document.ormsForm;
					f.method.value="Main";
			        f.commkind.value="ovs";
			        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
			        f.process_id.value="ORVS010201";
					f.target = "ifrORVS0102";
					f.submit();
					break;	 
					
			
			}
		}
		
		
		
		function doSave() {
			mySheet.DoSave(url, { Param : "method=Main&commkind=ovs&process_id=ORVS010103&dcz_dc="+$("#dcz_dc").val()+"&sch_rtn_cntn="+$("#sch_rtn_cntn").val()+"&dcz_objr_eno="+$("#dcz_objr_eno").val(), Col : 0 });
		}		
		
		// 해외법인 보고서 작성 팝업
		function popORVS0102(){
			var f = document.ormsForm;
			f.method.value="Main";
	        f.commkind.value="ovs";
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        f.process_id.value="ORVS010201";
	        f.target = "ifrORVS0102";
			f.submit();
		}
		
		function mySheet_OnSearchEnd(code, message) {
			

			
			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
			}
			
			//컬럼의 너비 조정
			mySheet.FitColWidth();
		}
		
		function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 

			if(Row >= mySheet.GetDataFirstRow())
			{
				btn_rg(mySheet.GetCellValue(Row,"bas_ym"));
			}
		}
		
		
		function mySheet_OnSaveEnd(code, msg) {
			
		    if(code >= 0) {
		        alert("완료 되었습니다.");  // 저장 성공 메시지
		        $("#winDcz").hide();
		        doAction("search");      
		    } else {
		        alert(msg); // 저장 실패 메시지
		    }
		
		}
		
		function mySheet_OnRowSearchEnd(Row) {
		
			mySheet.SetCellText(Row,"btn_rg",'<button class="btn btn-xs btn-default" type="button" onclick="btn_rg(\''+mySheet.GetCellValue(Row,"bas_ym")+'\')""> <span class="txt">조회/수정</span><i class="fa fa-caret-right ml5"></i></button>')
			mySheet.SetCellValue(Row,"status","R");
			mySheet.SetCellText(Row,"DetailDcz",'<button class="btn btn-xs btn-default" type="button" onclick="DczStatus(\''+mySheet.GetCellValue(Row,"bas_ym")+'\')"> <span class="txt">상세</span><i class="fa fa-caret-right ml5"></i></button>')
			
		}
		
	function DczStatus(bas_ym) {
		$("#rpst_id").val(bas_ym);
		$("#bas_pd").val(bas_ym);
		schDczPopup(3);
	}
		
		
	function btn_rg(bas_ym){
		for(var Row = mySheet.GetDataFirstRow(); Row<=mySheet.GetDataLastRow(); Row++){
			if(mySheet.GetCellValue(Row,"bas_ym")==bas_ym){
				$("#popBas_ym").val(mySheet.GetCellValue(Row,"bas_ym"));
				doAction('mod');
				break;
			}
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
			<input type="hidden" id="jsonData" name="jsonData" /> <!-- jsonData(String) -->
			<input type="hidden" id="mode" name="mode" /> <!-- 팝업 모드(I:저장, R:조회용) -->
			<input type="hidden" id="dcz_dc" name="dcz_dc" />
			<input type="hidden" id="popBas_ym" name="popBas_ym" /> <!-- 팝업 Bas_ym -->
			<input type="hidden" id="table_name" name="table_name" value="TB_OR_CF_ADM_DCZ"/>
			<input type="hidden" id="dcz_code" name="stsc_column_name" value="OVRS_DCZ_PRG_STSC"/>
			<input type="hidden" id="rpst_id_column" name="rpst_id_column" value="BAS_YM"/>
			<input type="hidden" id="rpst_id" name="rpst_id" value=""/>
			<input type="hidden" id="bas_pd_column" name="bas_pd_column" value="BAS_YM"/>
			<input type="hidden" id="bas_pd" name="bas_pd" value=""/>
			<input type="hidden" id="dcz_objr_emp_auth" name="dcz_objr_emp_auth" value=""/>
			<input type="text" id="sch_rtn_cntn" name="sch_rtn_cntn" value=""/>
			<input type="hidden" id="dcz_objr_eno" name="dcz_objr_eno" value=""/>
			<!-- 조회 -->
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								<tr>
									<th>보고 년월</th>
									<td>

										<select name="bas_yy" id="bas_yy" class="form-control w100">
											<option value="">전체</option>
												
<%
		
		for(int i=0;i<vLst1.size();i++){
			HashMap hMap = (HashMap)vLst1.get(i);
			
%>
												
											<option value="<%=(String)hMap.get("bas_yy")%>"><%=(String)hMap.get("bas_yy")%></option>
<%
	}
%>
										</select>
									</td>
									<th>년</th>	
									<td>
										<select name="bas_mm" id="bas_mm" class="form-control w100">
<%
%>
											<option value="">전체</option>
											<option value=01>1</option>
											<option value=02>2</option>
											<option value=03>3</option>
											<option value=04>4</option>
											<option value=05>5</option>
											<option value=06>6</option>
											<option value=07>7</option>
											<option value=08>8</option>
											<option value=09>9</option>
											<option value=10>10</option>
											<option value=11>11</option>
											<option value=12>12</option>
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
			<!-- //조회 -->
			
			<!-- //보고서업로드 -->
					

			<section class="box box-grid">
				<div class="box-header">
					<div class="area-tool">
						<button type="button" class="btn btn-default btn-xs" onclick="doAction('add');"><i class="fa fa-plus"></i><span class="txt">추가</span></button>
					</div>
				</div>
				<div class="wrap-grid h540">
					<script> createIBSheet("mySheet", "100%", "100%"); </script>
				</div>
<%
if( form.get("ovrs_menu_dsc").equals("1") ){ //ORM담당자
 %>						
				<div class="box-footer">
					<div class="btn-wrap">
						<button class="btn btn-primary" type="button" onclick="doAction('dcsRpsp');"><span class="txt">결재상신</span></button>
					</div>
				</div>
<%
}
else
if( form.get("ovrs_menu_dsc").equals("2") ){ //ORM팀장
%>						
				<div class="box-footer">
					<div class="btn-wrap">
						<button class="btn btn-primary" type="button" onclick="doAction('dczCmp');"><span class="txt">결재</span></button>
					</div>
				</div>
<%
}
%>

			</section>
		
		</form>
		</div>
		<!-- content //-->
		
	</div>
	
	<!-- popup -->
	<div id="winORVS0102" class="popup modal">
		<iframe name="ifrORVS0102" id="ifrORVS0102" src="about:blank"></iframe>
	</div>
	<script>
		// 결재팝업 연동 - 결재요청
		function DczSearchEndSub(){
			doSave();
		}
		// 결재팝업 연동 - 결재
		function DczSearchEndCmp(){
			doSave();
		}
		// 결재팝업 연동 - 반려
		function DczSearchEndRtn(){
			doSave();
		}
		// 결재팝업 연동 - 회수
		function DczSearchEndCncl(){
			doCncl();
		}
	</script>
	<%@ include file="../comm/PrssInfP.jsp" %> <!-- 업무프로세스 공통 팝업 -->
</body>
</html>