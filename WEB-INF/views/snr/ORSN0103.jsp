<%--
/*---------------------------------------------------------------------------
 Program ID   : ORSN0103.jsp
 Program name : 고위험 업무 등록
 Description  : SCNR-0102
 Programer    : 고창호
 Date created : 2022.08.24
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
response.setHeader("Pragma", "No-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Expires", "0");

Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit02", 0, "vList");
if(vLst==null) vLst = new Vector();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	
	<script>
		$(document).ready(function(){
			parent.removeLoadingWs(); //부모창 프로그래스바 비활성화
			
			$('#sch_snro_sc').val(parent.ormsForm.snro_sc.value); //바닥창에서 선택한 평가회차 세팅
			
			// ibsheet 초기화
			initIBSheet();
			
		});
		
		
		/*Sheet 기본 설정 */
		function initIBSheet() {
			//시트 초기화
			mySheet.Reset();
			
			var initData = {};

			/*mySheet*/
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":1, HeaderCheck:0, Sort:0,ChildPage:5,DeferredVScroll:1,AutoFitColWidth:"search|init|resize"};
			
			initData.Cols = [
			    {Header: "선택|선택", Type:"CheckBox",Width:40,Align:"Center",SaveName:"check",MinWidth:40},
				{Header: "업무프로세스|Lv.1", Type:"Text",Width:150,Align:"Center",SaveName:"lv1_bsn_prsnm",MinWidth:100,Edit:false},
				{Header: "업무프로세스|Lv.2", Type:"Text",Width:150,Align:"Center",SaveName:"lv2_bsn_prsnm",MinWidth:100,Edit:false},
				{Header: "업무프로세스|Lv.3", Type:"Text",Width:150,Align:"Center",SaveName:"lv3_bsn_prsnm",MinWidth:100,Edit:false},
				{Header: "업무프로세스|Lv.4", Type:"Text",Width:150,Align:"Center",SaveName:"lv4_bsn_prsnm",MinWidth:100,Edit:false},
				{Header: "최근 1년간 위험 정보 발생 내역 및 환산 점수|손실사건 발생건수\n(100만원 이상)", Type:"Int",Width:150,Align:"Center",SaveName:"lsoc_cn",MinWidth:100,Edit:false,Format:"#,##0"},
				{Header: "최근 1년간 위험 정보 발생 내역 및 환산 점수|KRI Red발생 건수", Type:"Int",Width:150,Align:"Center",SaveName:"kri_ocu_cn",MinWidth:100,Edit:false,Format:"#,##0"},
				{Header: "최근 1년간 위험 정보 발생 내역 및 환산 점수|RCSA 위험평가\nRed발생 건수", Type:"Int",Width:150,Align:"Center",SaveName:"ra_ocu_cn",MinWidth:100,Edit:false,Format:"#,##0"},
				{Header: "최근 1년간 위험 정보 발생 내역 및 환산 점수|RCSA 통제평가\n'하'발생 건수", Type:"Int",Width:150,Align:"Center",SaveName:"ctev_ocu_cn",MinWidth:100,Edit:false,Format:"#,##0"},
				{Header: "최종 위험\n점수 합계|최종 위험\n점수 합계", Type:"Float",Width:150,Align:"Center",SaveName:"ls_rsk_scr",MinWidth:100,Edit:false,Format:"#,##0.##"},
				{Header: "위험업무\n여부|위험업무\n여부", Type:"Text",Width:150,Align:"Center",SaveName:"rsk_bsn_yn",MinWidth:100,Edit:false},
				{Header: "", Type:"Status",Width:50,Align:"Center",HAlign:"Center",SaveName:"status",MinWidth:40,Edit:false,Hidden:true},
				{Header: "", Type:"Text",Width:150,Align:"Center",SaveName:"grp_org_c_p",MinWidth:100,Edit:false,Hidden:true},
				{Header: "", Type:"Text",Width:150,Align:"Center",SaveName:"snro_sc",MinWidth:100,Edit:false,Hidden:true},
				{Header: "", Type:"Text",Width:150,Align:"Center",SaveName:"bsn_prss_c",MinWidth:100,Edit:false,Hidden:true}
			];
			/*mySheet end*/
			
			IBS_InitSheet(mySheet,initData);
			
			mySheet.SetMergeSheet(eval("msHeaderOnly"));
			
			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			//mySheet.SetCountPosition(3);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			//컬럼의 너비 조정
			//mySheet.FitColWidth();
		
			doAction('search');
			
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
					var opt = {};
					
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("snr");
					$("form[name=ormsForm] [name=process_id]").val("ORSN010302");
					

					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "reload":  //조회데이터 리로드
				
					mySheet.RemoveAll();
					initIBSheet();
					break;
				case "rskBsnY":	//위험업무 등록
					var f = document.ormsForm;
					
					var sRow = mySheet.FindStatusRow("U");
					var arrow = sRow.split(";");
					
					if(arrow == ""){
						alert("선택된 항목이 없습니다.");
						return;
					}
					
					//진행상태 체크 (게시완료된 기사가 있는경우 return)
					for(var i=0; i<arrow.length; i++){
						if(mySheet.GetCellValue(arrow[i], "rsk_bsn_yn") == "Y"){ //이미 위험업무 등록여부가 Y
							alert("이미 위험업무 등록여부가 Y 항목이 포함되어 있습니다.["+(arrow[i]-1)+"]");
							return;
						}
					}
					
					$("#gubun").val("Y"); //위험업무 등록
					mySheet.DoSave(url + "?method=Main&commkind=snr&process_id=ORSN010303", FormQueryStringEnc(document.ormsForm));
					
					break;
				case "rskBsnN":	//위험업무 제외
					var f = document.ormsForm;
					
					var sRow = mySheet.FindStatusRow("U");
					var arrow = sRow.split(";");
					
					if(arrow == ""){
						alert("선택된 항목이 없습니다.");
						return;
					}
					
					//진행상태 체크 (게시완료된 기사가 있는경우 return)
					for(var i=0; i<arrow.length; i++){
						if(mySheet.GetCellValue(arrow[i], "rsk_bsn_yn") == "N"){ //이미 위험업무 등록여부가 N
							alert("이미 위험업무 등록여부가 N 항목이 포함되어 있습니다.["+(arrow[i]-1)+"]");
							return;
						}
					}
				
					$("#gubun").val("N"); //위험업무 제외
					mySheet.DoSave(url + "?method=Main&commkind=snr&process_id=ORSN010303", FormQueryStringEnc(document.ormsForm));
					
					break;
				case "down2excel":
					setExcelFileName("고위험 업무 목록");
					setExcelDownCols("0|1|2|3|4|5");
					mySheet.Down2Excel(excel_params);
	
					break;
			}
		}
		
		function mySheet_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				ORSN010305(); //계산요청일시, 최종계산일시 조회
			}
			
			//컬럼의 너비 조정
			//mySheet.FitColWidth();
		}
		
		//계산요청일시, 최종계산일시 조회
		function ORSN010305(){
			var f = document.ormsForm;
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "snr");
			WP.setParameter("process_id", "ORSN010305");
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
							for (var i=0;i < rList.length ; i++ ){
								$('#span_clc_rqr_dtm').html(rList[i].clc_rqr_dtm); //계산요청일시
								$('#span_ls_clc_dtm').html(rList[i].ls_clc_dtm); //최종계산일시
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
		
		function mySheet_OnSaveEnd(code, msg) {
			
		    if(code >= 0) {
		        alert("저장 되었습니다.");  // 저장 성공 메시지
		        doAction("search");
		        parent.doAction("search"); //부모창 재조회
		    } else {
		        alert(msg); // 저장 실패 메시지
		    }
		}
		
		// 최종 위험점수 계산
		function doCalc() {
			var f = document.ormsForm;
			
			if(f.sch_snro_sc.value.trim()==''){
				alert("평가회차정보가 없습니다.");
				f.acc_sbjnm.focus();
				return;
			}
			
			if(!confirm("현재 평가진행중인경우 진행중 데이터는 삭제됩니다.\n실행하시겠습니까?")) return;
			
			WP.clearParameters();
			WP.setParameter("method", "Main");
			WP.setParameter("commkind", "snr");
			WP.setParameter("process_id", "ORSN010304");
			WP.setForm(f);
			
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var inputData = WP.getParams();
			
			showLoadingWs(); // 프로그래스바 활성화
			WP.load(url, inputData,
				{
					success: function(result){
						if(result!='undefined' && result.rtnCode=="S") {
							alert("완료 하였습니다.");
							doAction('search');
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
		
		<%-- 업무프로세스 시작 --%>			
		// 업무프로세스검색 완료
		var PRSS4_ONLY = true; 
		var CUR_BSN_PRSS_C = "";
		
		function prss_popup(){
			CUR_BSN_PRSS_C = $("#sch_bsn_prss_c").val();
			if(ifrPrss.cur_click!=null) ifrPrss.cur_click();
			schPrssPopup();
		}
		
		function prssSearchEnd(bsn_prss_c, bsn_prsnm
							, bsn_prss_c_lv1, bsn_prsnm_lv1
							, bsn_prss_c_lv2, bsn_prsnm_lv2
							, bsn_prss_c_lv3, bsn_prsnm_lv3
							, biz_trry_c_lv1, biz_trry_cnm_lv1
							, biz_trry_c_lv2, biz_trry_cnm_lv2){
			$("#sch_bsn_prss_c").val(bsn_prss_c);
			$("#sch_prss_nm").val(bsn_prsnm);
			
			$("#winPrss").hide();
		}
		
		function prss_remove(){
			$("#sch_bsn_prss_c").val("");
			$("#sch_prss_nm").val("");
		}
		<%-- 업무프로세스 끝 --%>
	</script>
</head>
<body onkeyPress="return EnterkeyPass()">
	<div class="popup modal block">
			<div class="p_frame w1100">

				<div class="p_head">
					<h1 class="title">고위험 업무 등록</h1>
				</div>


				<div class="p_body">
					
					<div class="p_wrap">

						<div class="box box-search">
							<form name="ormsForm">
							<input type="hidden" id="path" name="path" />
							<input type="hidden" id="process_id" name="process_id" />
							<input type="hidden" id="commkind" name="commkind" />
							<input type="hidden" id="method" name="method" />
							
							<input type="hidden" id="gubun" name="gubun" /> <!-- 위험업무 등록 제외 구분 (Y:등록, N:제외) -->
							<div class="box-body">
								<div class="wrap-search">
									<table>
										<tbody>
											<tr>
												<th>평가회차</th>
												<td>
												<input type="text" class="form-control w100 fl" id="sch_snro_sc" name="sch_snro_sc" readonly/>
<%-- 													<select name="sch_snro_sc" id="sch_snro_sc" class="form-control" disabled>
<%
		for(int i=0;i<vLst.size();i++){
			HashMap hMap = (HashMap)vLst.get(i);
%>
														<option value="<%=(String)hMap.get("snro_sc")%>"><%=(String)hMap.get("snro_sc")%></option>
<%
		}
%>
													</select> --%>
												</td>
												<th>업무프로세스</th>
												<td class="form-inline">
													<div class="input-group">
														<input type="text" id="sch_prss_nm" name="sch_prss_nm" class="form-control w150" readonly>
														<input type="hidden" class="form-control" id="sch_bsn_prss_c" name="sch_bsn_prss_c">
														<span class="input-group-btn">
															<button type="button" class="btn btn-default ico" onclick="prss_popup();"><i class="fa fa-search"></i><span class="blind">업무프로세스 선택</span></button>
															<button type="button" class="btn btn-default ico" onclick="prss_remove();"><i class="fa fa-times-circle"></i></button>
														</span>
													</div>
												</td>
											</tr>
											<tr>
												<th>최종위험점수합계</th>
												<td colspan="3" class="form-inline">
													<div class="input-group">
														<input type="text" class="form-control w100" id="sch_ls_rsk_scr_from" name="sch_ls_rsk_scr_from" placeholder="0.0">
														<div class="input-group-addon"> 이상 </div>
													</div>
													<div class="input-group">
														<div class="input-group-addon"> ~ </div>
														<input type="text" class="form-control w100" id="sch_ls_rsk_scr_to" name="sch_ls_rsk_scr_to"  placeholder="0.0">
														<div class="input-group-addon"> 이하 </div>
													</div>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							</form>
							<div class="box-footer">
								<button type="button" class="btn btn-primary search" onclick="doAction('search');">조회</button>
							</div>
						</div>

						<section class="box box-grid">						
							<div class="box-header">		
								<div class="area-term">
									<span class="tit">계산요청일시</span>
									<strong id="span_clc_rqr_dtm" class="em"></strong>
									<span class="div">/</span>
									<span class="tit">최종계산일시</span>
									<strong id="span_ls_clc_dtm" class="em"></strong>
								</div>
								<div class="area-tool">
									<button type="button" class="btn btn-default btn-xs" onclick="doCalc();"><i class="fa fa-calculator"></i><span class="txt">위험점수 계산</span></button>
								<!-- 	<button type="button" class="btn btn-default btn-xs">
										<i class="fa fa-sort-amount-desc"></i>
										<span class="txt">내림차순 정렬</span>
									</button>  -->
								</div>
							</div> 
							<div class="wrap-grid h300">
								<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%"); </script>
							</div>
							<div class="box-footer">
								<!-- <p style="margin-top:6px;margin-bottom:2px;"><span style="color:blue">※ '최종 위험점수 계산' 버튼을 클릭하여 1년간 정보를 불러온 후 등록 하여 주세요.</span></p>-->
								 <div class="btn-wrap">
									<button type="button" class="btn btn-primary btn-sm" onclick="doAction('rskBsnY');">
										<i class="fa fa-plus"></i><span class="txt">위험업무 등록</span>
									</button>
									<button type="button" class="btn btn-default btn-sm" onclick="doAction('rskBsnN');">
										<i class="fa fa-minus"></i><span class="txt">위험업무 제외</span>
									</button>
								</div>
							</div>
						</section>

					</div>
					
				</div>


				<div class="p_foot">
					<div class="btn-wrap">
						<!-- <button type="button" class="btn btn-primary">저장</button> -->
						<button type="button" class="btn btn-default btn-close">닫기</button>
					</div>
				</div>

				<button class="ico close fix btn-close"><span class="blind">닫기</span></button>

			</div>
		<div class="dim p_close"></div>
	</div>
<%@ include file="../comm/PrssInfP.jsp" %> <!-- 업무프로세스 공통 팝업 -->
</body>

<script>
	$(document).ready(function(){
		//열기
		$(".btn-open").click( function(){
			$(".popup").show();
		});
		//닫기
		$(".btn-close").click( function(){
			$(".popup",parent.document).hide();
		});
	});
		
	function closePop(){
		$("#winNewAccAdd",parent.document).hide();
	}
</script>

</html>