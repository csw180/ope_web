<%--
/*---------------------------------------------------------------------------
 Program ID   : ORRC0112.jsp
 Program name : 관련KRI(과거1년)
 Description  : 화면정의서 RCSA-08.2.2
 Programer    : 박승윤
 Date created : 2022.09.16
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
response.setHeader("Pragma", "No-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Expires", "0");
DynaForm form = (DynaForm)request.getAttribute("form");
String rk_isc_cntn = form.get("link_rk_isc_cntn");

Vector vLst = CommUtil.getResultVector(request, "grp01", 0, "unit02", 0, "vList");
if(vLst==null) vLst = new Vector();


HashMap<String, String> bas_Ym = new HashMap<String,String>();

String input_pivot_basym = "";

for(int i=0;i<vLst.size();i++){
	HashMap hMap = (HashMap)vLst.get(i);
    bas_Ym.put("bas_ym"+i,(String)hMap.get("bas_ym"));		
}



%>
<!DOCTYPE html>
<html lang="ko">
	<head>
	<%@ include file="../comm/library.jsp" %>
	<script language="javascript">
		
	$(document).ready(function(){
		
		parent.removeLoadingWs();
		$("#rk_isc_cntn").text("<%=rk_isc_cntn%>");
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
			{Header:"KRI ID|KRI ID",Type:"Text",Width:100,Align:"Center",SaveName:"oprk_rki_id",MinWidth:100,Edit:0},
			{Header:"지표명|지표명",Type:"Text",Width:200,Align:"Center",SaveName:"oprk_rkinm",MinWidth:200,Edit:0},
     		{Header:"KRI등급\n(지표값)|"+exChange_columnNm("<%=(String)bas_Ym.get("bas_ym0")%>"),Type:"Float",Format:"#,##0.###",Width:200,Align:"Center",SaveName:"bas_ym0",MinWidth:50,Edit:0},
     		{Header:"KRI등급\n(지표값)|"+exChange_columnNm("<%=(String)bas_Ym.get("bas_ym1")%>"),Type:"Float",Format:"#,##0.###",Width:200,Align:"Center",SaveName:"bas_ym1",MinWidth:50,Edit:0},
     		{Header:"KRI등급\n(지표값)|"+exChange_columnNm("<%=(String)bas_Ym.get("bas_ym2")%>"),Type:"Float",Format:"#,##0.###",Width:200,Align:"Center",SaveName:"bas_ym2",MinWidth:50,Edit:0},
     		{Header:"KRI등급\n(지표값)|"+exChange_columnNm("<%=(String)bas_Ym.get("bas_ym3")%>"),Type:"Float",Format:"#,##0.###",Width:200,Align:"Center",SaveName:"bas_ym3",MinWidth:50,Edit:0},
     		{Header:"KRI등급\n(지표값)|"+exChange_columnNm("<%=(String)bas_Ym.get("bas_ym4")%>"),Type:"Float",Format:"#,##0.###",Width:200,Align:"Center",SaveName:"bas_ym4",MinWidth:50,Edit:0},
     		{Header:"KRI등급\n(지표값)|"+exChange_columnNm("<%=(String)bas_Ym.get("bas_ym5")%>"),Type:"Float",Format:"#,##0.###",Width:200,Align:"Center",SaveName:"bas_ym5",MinWidth:50,Edit:0},
     		{Header:"KRI등급\n(지표값)|"+exChange_columnNm("<%=(String)bas_Ym.get("bas_ym6")%>"),Type:"Float",Format:"#,##0.###",Width:200,Align:"Center",SaveName:"bas_ym6",MinWidth:50,Edit:0},
     		{Header:"KRI등급\n(지표값)|"+exChange_columnNm("<%=(String)bas_Ym.get("bas_ym7")%>"),Type:"Float",Format:"#,##0.###",Width:200,Align:"Center",SaveName:"bas_ym7",MinWidth:50,Edit:0},
     		{Header:"KRI등급\n(지표값)|"+exChange_columnNm("<%=(String)bas_Ym.get("bas_ym8")%>"),Type:"Float",Format:"#,##0.###",Width:200,Align:"Center",SaveName:"bas_ym8",MinWidth:50,Edit:0},
     		{Header:"KRI등급\n(지표값)|"+exChange_columnNm("<%=(String)bas_Ym.get("bas_ym9")%>"),Type:"Float",Format:"#,##0.###",Width:200,Align:"Center",SaveName:"bas_ym9",MinWidth:50,Edit:0},
     		{Header:"KRI등급\n(지표값)|"+exChange_columnNm("<%=(String)bas_Ym.get("bas_ym10")%>"),Type:"Float",Format:"#,##0.###",Width:200,Align:"Center",SaveName:"bas_ym10",MinWidth:50,Edit:0},
     		{Header:"KRI등급\n(지표값)|"+exChange_columnNm("<%=(String)bas_Ym.get("bas_ym11")%>"),Type:"Float",Format:"#,##0.###",Width:200,Align:"Center",SaveName:"bas_ym11",MinWidth:50,Edit:0}
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
				case "search":		//저장
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("rsa");
					$("form[name=ormsForm] [name=process_id]").val("ORRC011202");

					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					break;

			}
		}

		function mySheet_OnSearchEnd(code, message) {

		    if(code == 0) {
		    	mySheet.FitColWidth();
		        //조회 후 작업 수행
		
			} else {
		
			        alert("조회 중에 오류가 발생하였습니다..");
			        
		
			}

		}
		
		function exChange_columnNm(columnNm){
		  return "'"+columnNm.substr(2,2)+"."+columnNm.substr(4,2);
		}
	</script>
	</head>
<body>
	<form name="ormsForm" method="post">
	<input type="hidden" id="path" name="path" />
	<input type="hidden" id="process_id" name="process_id" />
	<input type="hidden" id="commkind" name="commkind" />
	<input type="hidden" id="method" name="method" />
	<input type="hidden" id="rkp_id" name="rkp_id" value="<%=form.get("rkp_id")%>" />
		<div id="" class="popup modal block">
			<div class="p_frame w1500">
	
				<div class="p_head">
					<h3 class="title">관련 KRI지표(1개년)</h3>
				</div>
	
				<div class="p_body">
					<div class="p_wrap">
	
					<div class="wrap-table">
							<table>
								<thead>
									<th scope="col">리스크 사례</th>
								</thead>
								<tbody>
									<tr>
										<td id = "rk_isc_cntn">										
										</td>
									</tr>
								</tbody>
							</table>
					</div>
	
						<div class="box box-grid mt20">
<!-- 							<div class="box-header">
								<div class="area-tool">
									<button type="button" class="btn btn-xs btn-default" onclick="doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>	
								</div>
							</div> -->
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