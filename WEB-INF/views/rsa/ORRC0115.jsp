<%--
/*---------------------------------------------------------------------------
 Program ID   : ORRC0115.jsp
 Program name : 진행현황 상세보기 팝업
 Description  : 화면정의서 RCSA-09.1
 Programer    : 박승윤
 Date created : 2022.09.01
 ---------------------------------------------------------------------------*/
--%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.shbank.orms.comm.SysDateDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%

DynaForm form = (DynaForm)request.getAttribute("form");
//String link_brnm = new String(form.get("link_brnm").getBytes("ISO8859_1"), "UTF-8");
ServletContext sctx = request.getSession(true).getServletContext();
String istest = sctx.getInitParameter("isTest");
String servergubun = sctx.getInitParameter("servergubun");

String link_brnm = form.get("link_brnm");

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


%>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="../comm/library.jsp" %>
	<script language="javascript">
		
	$(document).ready(function(){
		//$("#winRskMod",parent.document).addClass("block");
		
		parent.removeLoadingWs();
		
		// ibsheet 초기화
		initIBSheet();
		

	});
		

	/*Sheet 기본 설정 */
	function initIBSheet() {
		//시트 초기화
		mySheet.Reset();
		
		var initData = {};
		
		initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; 
		initData.Cols = [
						{Header:"No",Type:"Seq",Width:30,Align:"Center",SaveName:"num",MinWidth:30,Edit:0},			
		    			{Header:"그룹내기관코드",Type:"Text",Width:0,Align:"Center",SaveName:"grp_org_c",MinWidth:60, Hidden:true},
		    			{Header:"사무소코드",Type:"Text",Width:0,Align:"Center",SaveName:"brc",MinWidth:60, Hidden:true},
						{Header:"업무 프로세스\nLV1",Type:"Text",Width:100,Align:"Left",SaveName:"prssnm1",MinWidth:100,Edit:0},
						{Header:"업무 프로세스\nLV2",Type:"Text",Width:100,Align:"Left",SaveName:"prssnm2",MinWidth:100,Edit:0},
						{Header:"업무 프로세스\nLV3",Type:"Text",Width:100,Align:"Left",SaveName:"prssnm3",MinWidth:100,Edit:0},
						{Header:"업무 프로세스\nLV4",Type:"Text",Width:100,Align:"Left",SaveName:"prssnm4",MinWidth:100,Edit:0},
		    			{Header:"리스크사례ID",Type:"Text",Width:0,Align:"Center",SaveName:"rkp_id",MinWidth:60,Edit:0},
						{Header:"리스크평가기준년월",Type:"Text",Width:0,Align:"Center",SaveName:"bas_ym",MinWidth:60, Hidden:true},
						{Header:"평가부서",Type:"Text",Width:100,Align:"Center",SaveName:"dept_brnm",MinWidth:100,Edit:0, Hidden:true},
						{Header:"팀",Type:"Text",Width:100,Align:"Center",SaveName:"brnm",MinWidth:100,Edit:0, Hidden:true},
		    			{Header:"리스크 사례",Type:"Text",Width:100,Align:"Left",SaveName:"rk_isc_cntn",MinWidth:60,Edit:0},
						{Header:"통제활동",Type:"Text",Width:300,Align:"Left",SaveName:"cp_cntn",MinWidth:200,Edit:0, Hidden:true},
						{Header:"위험\n등급",Type:"Combo",Width:80,Align:"Center",SaveName:"rk_evl_grd_c",MinWidth:60,ComboText:"<%=rkEvlGrdNm%>", ComboCode:"<%=rkEvlGrdC%>",Edit:0},
						{Header:"통제\n등급",Type:"Combo",Width:80,Align:"Center",SaveName:"ctev_grd_c",MinWidth:60,ComboText:"<%=rkCtlDsgEvlNm%>", ComboCode:"<%=rkCtlDsgEvlC%>",Edit:0},
						{Header:"잔여위험\n등급",Type:"Combo",Width:80,Align:"Center",SaveName:"rmn_rsk_grd_c",MinWidth:60,ComboText:"<%=rkRmnRskGrdNm%>", ComboCode:"<%=rkRmnRskGrdC%>",Edit:0},
						{Header:"평가\n상태",Type:"Text",Width:0,Align:"Center",SaveName:"evl_stsc",MinWidth:60,Edit:0},
						{Header:"평가자개인번호",Type:"Text",Width:0,Align:"Center",SaveName:"vlr_eno",MinWidth:60, Hidden:true},
						{Header:"평가자",Type:"Text",Width:100,Align:"Center",SaveName:"vlr_nm",MinWidth:100,Edit:0,MultiLineText:1},
						{Header:"재평가\n대상여부",Type:"Text",Width:100,Align:"Center",SaveName:"reevl_yn",MinWidth:100,Edit:0, Hidden:true},
						{Header:"결재요청\n여부",Type:"Text",Width:100,Align:"Center",SaveName:"dcz_rq_yn",MinWidth:100,Edit:0, Hidden:true},
						{Header:"결재 완료\n여부",Type:"Text",Width:100,Align:"Center",SaveName:"dcz_yn",MinWidth:100,Edit:0, Hidden:true},				
		    			{Header:"반송사유",Type:"Text",Width:60,Align:"Left",SaveName:"rtn_cntn",MinWidth:100,Edit:0, Hidden:true}, 				
						{Header:"결재\n진행단계",Type:"Combo",Width:80,Align:"Center",SaveName:"rk_evl_dcz_stsc",MinWidth:60,ComboText:"<%=rkEvlDczStnm%>", ComboCode:"<%=rkEvlDczStsc%>",Edit:0, Hidden:true}
			
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
		
		doAction('search');

		
	}
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
				case "search":		//조회 처리
				
					DoSaerch();
					break; 
				case "down2excel":
					
					var params = {ExcelHeaderRowHeight:25, ExcelRowHeight:17, ExcelFontSize:10, FileName : "RCSA진행현황상세.xlsx", SheetName : "Sheet1", Merge:1, DownCols:"0|1|3|5|7|9|10|11|12|13|14|15|16|18"} ;
					mySheet.Down2Excel(params);

					break;
			}
		}
		

		
		function DoSaerch() {
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var opt = {};
			$("form[name=ormsForm] [name=method]").val("Main");
			$("form[name=ormsForm] [name=commkind]").val("rsa");
			$("form[name=ormsForm] [name=process_id]").val("ORRC011502");

			mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
		}

		function mySheet_OnSearchEnd(code, message) {

		    if(code == 0) {
		        //조회 후 작업 수행
		    	mySheet.FitColWidth();
			} else {
		
				alert("조회 중에 오류가 발생하였습니다..");
			}

		}
		
	</script>

</head>
<body>
	<form name="ormsForm" method="post">
	<input type="hidden" id="path" name="path" />
	<input type="hidden" id="process_id" name="process_id" />
	<input type="hidden" id="commkind" name="commkind" />
	<input type="hidden" id="method" name="method" />
	<input type="hidden" id="brc" name="brc" value=<%=form.get("link_brc")%> >
		<div id="" class="popup modal block">
			<div class="p_frame w1100">
	
				<div class="p_head">
					<h3 class="title">진행현황 상세보기</h3>
				</div>
	
				<div class="p_body">
					<div class="p_wrap">
	
						<div class="box-box-grid">
							<div class="wrap-table">
								<table>
									<colgroup>
										<col style="width: 80px;">
										<col>
										<col style="width: 80px;">
										<col>
									</colgroup>
									<tr>
										<th>조직</th>
										<td><%=link_brnm%></td>
										<th>완료일자</th>
										<td>
											<div class="form-inline">
												<div class="input-group">
													<input type="text" class="form-control w100" id="st_dt" name="st_dt" value="<%=form.get("st_dt")%>" readonly>
												</div>
												<div class="input-group">
													<div class="input-group-addon"> ~ </div>
													<input type="text" class="form-control w100" id="ed_dt" name="ed_dt" value="<%=form.get("ed_dt")%>" readonly>
												</div>
											</div>
										</td>
									</tr>
								</table>
							</div>						
						</div>
	
						<div class="box box-grid mt20">
							<div class="box-header">
								<div class="area-tool">
									<button type="button" class="btn btn-xs btn-default" onclick="doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>	
								</div>
							</div>
							<div class="box-body">
								<div class="wrap-grid h300">
									<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%"); </script>
								</div>
							</div>
						</div>
	
					</div>
				</div>
	
				<div class="p_foot">
					<div class="btn-wrap center">
						<button type="button" class="btn btn-default btn-close">닫기</button>
					</div>
				</div>
				<button type="button" class="ico close fix btn-close"><span class="blind">닫기</span></button>
	
			</div>
			<div class="dim p_close"></div>
		</div>
	</form>
</body>

<script>
	$(document).ready(function(){
		//열기
		$(".btn-open").click( function(){
			$(".popup").addClass("block");
		});
		//닫기
		$(".btn-close").click( function(){
			$(".popup",parent.document).hide();
		});
	});
</script>
</html>