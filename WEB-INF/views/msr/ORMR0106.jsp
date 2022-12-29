<%--
/*---------------------------------------------------------------------------
 Program ID   : ORMR0106.jsp
 Program name : 영업지수요소(BIC) 산출
 Description  : MSR-07
 Programer    : 이규탁
 Date created : 2022.08.05
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
Vector vLst = CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();

Vector vSbdrLst= CommUtil.getCommonCode(request, "SBDR_C");
if(vSbdrLst==null) vSbdrLst = new Vector();

Vector vRgoLst= CommUtil.getCommonCode(request, "RGO_IN_DSC");
if(vRgoLst==null) vRgoLst = new Vector();



%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="../comm/library.jsp" %>
	<title>내부 자본량 측정 결과 조회</title>
	<script>
		
		$(document).ready(function(){
			
			// ibsheet 초기화
			initIBSheet();
			$("#sel_sbdr_c").val('');
			$("#sbdr_c").val('00');
			doAction('search');
			
		});
		

		/*Sheet 기본 설정 */
		function initIBSheet() {
			//시트 초기화
			mySheet.Reset();
			
			var initData = {};

			initData.Cfg = {FrozenCol:0,Sort:0,MergeSheet:msBaseColumnMerge + msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; 
		    initData.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:0};
			initData.Cols = [
				{Header:"영업지수요소 구분|1레벨코드"				,Type:"Text"	,Width:60	,Align:"Center"	,SaveName:"lv1_biz_ix_c"		,Edit:"False"	,Hidden:true 	},
				{Header:"영업지수요소 구분|구분"					,Type:"Text"	,Width:60	,Align:"Center"	,SaveName:"division"			,Edit:"False"	,ColMerge:1		},
				{Header:"영업지수요소 구분|2레벨코드"				,Type:"Text"	,Width:150	,Align:"Center"	,SaveName:"lv2_biz_ix_c"		,Edit:"False"	,Hidden:true 	},
				{Header:"영업지수요소 구분|항목"					,Type:"Text"	,Width:150	,Align:"Center"	,SaveName:"item"				,Edit:"False"	,ColMerge:0				},
				{Header:"분기별 BIC 구성요소|"+$("#bas_yq1").val()			,Type:"Text"	,Width:150	,Align:"Center"	,SaveName:"msr_am1"			,Edit:"False"	,ColMerge:0},
				{Header:"분기별 BIC 구성요소|"+$("#bas_yq2").val()			,Type:"Text"	,Width:150	,Align:"Center"	,SaveName:"msr_am2"			,Edit:"False"	,ColMerge:0},
				{Header:"분기별 BIC 구성요소|"+$("#bas_yq3").val()			,Type:"Text"	,Width:150	,Align:"Center"	,SaveName:"msr_am3"			,Edit:"False"	,ColMerge:0},
				{Header:"분기별 BIC 구성요소|ILDC, SC, FC 산출값"				,Type:"Text"	,Width:150	,Align:"Center"	,SaveName:"ildc_sc_fc_am"	,Edit:"False"	,ColMerge:1}
				];
			/*mySheet end*/
			
			IBS_InitSheet(mySheet,initData);
			

			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet.SetCountPosition(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			//컬럼의 너비 조정
			mySheet.FitColWidth();
		
			
		}
		
		var row = "";
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
		//시트 ContextMenu선택에 대한 이벤트
		function mySheet_OnSelectMenu(text,code){
			if(text=="엑셀다운로드"){
				doAction("down2excel");	
			}else if(text=="엑셀업로드"){
				doAction("loadexcel");
			}
		}
		
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
				case "search":  //데이터 조회
					if($('#sch_bas_yy').val() == "" || $('#sch_bas_yy').val() == null){
						alert("연도정보가 존재하지 않습니다. 관리자에게 문의하세요.");
						return;
					}
				
					var sch_bas_yy = $("#sch_bas_yy").val(); //조회년도
					var sch_bas_qq = $("#sch_bas_qq").val(); //조회분기
					var num_Q = "";
					switch(sch_bas_qq){
						case "03": num_Q = "1Q"; break;
						case "06": num_Q = "2Q"; break;
						case "09": num_Q = "3Q"; break;
						case "12": num_Q = "4Q"; break;
						}
					
					
					$("#bas_yq3").val(sch_bas_yy+" "+num_Q); 
					$("#bas_yq2").val(sch_bas_yy-1+" "+num_Q);
					$("#bas_yq1").val(sch_bas_yy-2+" "+num_Q);
					
					var opt = {};
					
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR010602");
					
					mySheet.RemoveAll();
					initIBSheet();
					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "help1":
					$("#ifrHelp1").attr("src","about:blank");
					$("#winHelp1").show();
					showLoadingWs(); // 프로그래스바 활성화
					setTimeout(modHelp1,1);
				case "reload":  //조회데이터 리로드
				
					mySheet.RemoveAll();
					initIBSheet();
					break;
				case "down2excel":
					
					setExcelFileName($("#bas_yq3").val() + "영업지수요소(BIC)산출.xlsx");
					setExcelDownCols("1|3|4|5|6|7");
					mySheet.Down2Excel(excel_params);
					break;
			}
		}
		function modHelp1(){ //분기 평판종합 상세내용
			var f = document.ormsForm;
			f.method.value="Main";
	        f.commkind.value="msr";
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        f.process_id.value="ORMR011001";
			f.target = "ifrHelp1";
			f.submit();
		}
		function mySheet_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				if(mySheet.GetDataFirstRow()>=0){
						mySheet.DataInsert(-1);
						mySheet.DataInsert(-1);
						
						mySheet.SetCellValue(mySheet.GetDataLastRow()-1,"lv1_biz_ix_c","BI");
						mySheet.SetCellValue(mySheet.GetDataLastRow()-1,"division","BI");
						mySheet.SetCellBackColor(mySheet.GetDataLastRow()-1,"division","f2f2f2");  
						mySheet.SetCellValue(mySheet.GetDataLastRow(),"lv1_biz_ix_c","BIC");
						mySheet.SetCellValue(mySheet.GetDataLastRow(),"division","BIC");
						mySheet.SetCellBackColor(mySheet.GetDataLastRow(),"division","a6a6a6");  
						mySheet.SetMergeCell(14, 1, 1, 6, 0);
						mySheet.SetMergeCell(15, 1, 1, 6, 0);
						mySheet.RenderSheet(2);  // 시트 강제 랜더링 처리
						ILDC_SC_FC_BI_BIC();
				}
			}
			//컬럼의 너비 조정
			mySheet.FitColWidth();
		}
		
		function rgo_change_func(rgo_in_dsc){
			var rgo_in_dsc = $(rgo_in_dsc).val();
			if(rgo_in_dsc == '1')
				{
					$("#sel_sbdr_c").attr('disabled',true);
					$("#sel_sbdr_c").val('');
					$("#sbdr_c").val('00');
				}
			else if(rgo_in_dsc == '2')
				{
					$("#sel_sbdr_c").attr('disabled',false);
					$("#sel_sbdr_c").val('01');
					$("#sbdr_c").val('01');
				}
		}
		
		function sbdr_change_func(sel_sbdr_c){
			var sel_sbdr_c = $(sel_sbdr_c).val();
			if(sel_sbdr_c == '01')
				{
					$("#sbdr_c").val('01');
				}
			else if(sel_sbdr_c == '02')
			    {
			    	$("#sbdr_c").val('02');
			    }
		}
		
		function ILDC_SC_FC_BI_BIC(){
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("msr");
				$("form[name=ormsForm] [name=process_id]").val("ORMR010603");
	
				var f = document.ormsForm;
				WP.clearParameters();
				WP.setForm(f);
	
				var url = "<%=System.getProperty("contextpath")%>/comMain.do";
				var inputData = WP.getParams();
				
				showLoadingWs(); // 프로그래스바 활성화
				WP.load(url, inputData,{
					success: function(result){
						
						var rList = result.DATA;
						if(result!='undefined') {
							
						for(var i=0;i<rList.length;i++){
						  for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
								if(mySheet.GetCellValue(j,"lv1_biz_ix_c")==rList[i].lv1_biz_ix_c){
									
									mySheet.SetCellValue(j,"ildc_sc_fc_am",rList[i].msr_am);
									break;
								}
							 }
						  }
					    }
					},
					
					
					complete: function(statusText,status) {
						removeLoadingWs();
					},
	
					error: function(rtnMsg) {
						alert(JSON.stringify(rtnMsg));
					}
				});
			}
		
	</script>
</head>
<body>
	<div class="container">
		<!-- page-header -->
		<%@ include file="../comm/header.jsp" %>
		<!-- page header //-->
		<!-- content -->
		<div class="content">
		<form name="ormsForm">
			<input type="hidden" id="path" name="path" />
			<input type="hidden" id="process_id" name="process_id" />
			<input type="hidden" id="commkind" name="commkind" />
			<input type="hidden" id="method" name="method" />
			<input type="hidden" id="bas_yq1" name="bas_yq1" value="" />
			<input type="hidden" id="bas_yq2" name="bas_yq2" value="" />
			<input type="hidden" id="bas_yq3" name="bas_yq3" value="" />
			<input type="hidden" id="sbdr_c" name="sbdr_c" value="" />

			<!-- 조회 -->
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								<tr>
									<th>연도 선택</th>
									<td>
										<div class="select w100">
											<select name="sch_bas_yy" id="sch_bas_yy" class="form-control">
<%
	for(int i=0;i<vLst.size();i++){
		HashMap hMap = (HashMap)vLst.get(i);
%>
												<option value="<%=(String)hMap.get("bas_yy")%>"><%=(String)hMap.get("bas_yy")%></option>
<%
	}
%>
											</select>
										</div>
									</td>
									<th>분기 선택</th>
									<td>
										<div class="select">
											<select name="sch_bas_qq" id="sch_bas_qq" class="form-control">
												<option value="03">1분기</option>
												<option value="06">2분기</option>
												<option value="09">3분기</option>
												<option value="12">4분기</option>
											</select>
										</div>
									</td>
								</tr>
								<tr>
									<th>측정방법</th>
									<td>
										<div class="select">
											<select name="rgo_in_dsc" id="rgo_in_dsc" class="form-control" onchange="rgo_change_func(this)">
<%
	for(int i=0;i<vRgoLst.size();i++){
		HashMap hMap = (HashMap)vRgoLst.get(i);
%>
												<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
<%
	}
%>
											</select>
										</div>
									</td>
									<th>발생 법인</th>
									<td>	
										<div class="select">
											<select name="sel_sbdr_c" id="sel_sbdr_c" class="form-control" onchange="sbdr_change_func(this)" disabled>
<%
	for(int i=0;i<vSbdrLst.size();i++){
		HashMap hMap = (HashMap)vSbdrLst.get(i);
%>
												<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
<%
	}
%>
											</select>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="box-footer">
					<button type="button" class="btn btn-default btn-xs" onclick="modalOpen('modalGuide');"><i class="fa fa-question-circle"></i><span class="txt">Help</span></button>
					<button type="button" class="btn btn-primary search" onclick="javascript:doAction('search');">조회</button>
				</div>
			</div>
			<!-- //조회 -->


			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">요약 정보</h2>
					<div class="area-tool">
						
						<button class="btn btn-xs btn-default" type="button" onclick="javascript:doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
					</div>
				</div>
				<div class="box-body">
					<div class="wrap-grid h500">
						<script> createIBSheet("mySheet", "100%", "100%"); </script>
					</div>
				</div>
			</section>
		
		</form>
		</div>
		<!-- content //-->
		
	</div>
	
	<!-- popup -->
	<article id="modalGuide" class="popup modal">
		<div class="p_frame w800">	
			<div class="p_head">
				<h3 class="title">영업지수요소(LC) 산출 가이드라인</h3>
			</div>
			<div class="p_body">						
				<div class="p_wrap">
				
					<section class="box box-grid">
						<div class="wrap-table">
							<table>
								<tbody>
									<tr>
										<th class="w120">영업지수요소<br>(BIC)</th>
										<td>
											<p class="math"><strong class="fsi">BI</strong> = <strong class="cm fsi">ILDC</strong> + <strong class="ca fsi">SC</strong> + <strong class="ci fsi">FC</strong></p>
											<ul class="ph2 pl25">
												<li><strong class="cm fsi">ILDC</strong> = <strong class="fsi">Min</strong>(|이자수익 - 이자비용|<em class="sup">*</em>, (이자수익자산<em class="sup">*</em> × <strong>2.25</strong>%)) + <strong>배당수익</strong><em class="sup">*</em></li>
												<li><strong class="ca fsi">SC</strong> = <strong class="fsi">Min</strong>(수수료수익<em class="sup">*</em>, 수수료비용<em class="sup">*</em>) + <strong class="fsi">Max</strong>(기타영업이익<em class="sup">*</em>, 기타영업비용<em class="sup">*</em>)</li>
												<li><strong class="ci fsi">FC</strong> = |이자수익<em class="sup">*</em>| - |트레이딩계정손익<em class="sup">*</em>|</li>
												<li class="txt txt-xs cr">* : 3개년 평균</li>
											</ul>
											<p class="math"><strong class="fsi">BIC</strong> = <strong class="fsi">BI</strong> + α(BI 계수)</p>
											<div class="ph5 pl20 pr10">
												<table class="intable">
													<thead>
														<tr>
															<th scope="col" class="w60">구분</th>
															<th scope="col">구간</th>
															<th scope="col" class="w80">BI 계수</th>
														</tr>
													</thead>
													<tbody class="center">
														<tr>
															<td>1</td>
															<td>1.4조원 이하</td>
															<td>12%</td>
														</tr>
														<tr>
															<td>2</td>
															<td>1.4조원 초과 42조원 이하</td>
															<td>15%</td>
														</tr>
														<tr>
															<td>3</td>
															<td>42조원 초과</td>
															<td>18%</td>
														</tr>
													</tbody>
												</table>
											</div>
											<div class="wrap-footnote pl20">
												<p class="txt txt-xs ca">※ BI계수는 BI산출금액에 따라 구간별 적용</p>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="alert alert-warning">
							<p class="box-title sm pb10">영업지수요소(BIC) 산출절차</p>
							<ul class="ullist">
								<li>1. 분기별 재무데이터 업로드(Templete)</li>
								<li>2. 분기데이터 조정
									<ul class="ullist">
										<li>1) BS계정금액 : 조정 X</li>
										<li>2) PL계정금액
											<ul class="ullist">
												<li>(1) 1분기값 : 조정 X</li>
												<li>(2) 2, 3, 4분기값 : 당분기 잔액 - 전분기 잔액</li>
											</ul>
										</li>
									</ul>
								</li>
								<li>3. 연도별 데이터 산출
									<ul class="ullist">
										<li>&rarr; 산출시점 기준 1개년 데이터를 영업지수요소별 합산하여 계산</li>
									</ul>
								<li>4. 이자손익, 트레이딩계정손익, 은행계정손익 등의 손익계정은 각 연도별 절댓값 산출 후 평균 적용</li>
							</ul>
						</div>
					</section>
				
				
				</div>						
			</div>
			<div class="p_foot">
				<div class="btn-wrap">
					<button type="button" class="btn btn-default btn-close" onclick="modalClose('modalGuide');">닫기</button>
				</div>
			</div>
			<button type="button" class="ico close fix btn-close" onclick="modalClose('modalGuide');"><span class="blind">닫기</span></button>	
		</div>
		<div class="dim p_close"></div>
	</article>
	<!-- popup //-->
</body>
</html>