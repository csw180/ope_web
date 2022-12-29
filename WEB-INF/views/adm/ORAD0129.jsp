<%--
/*---------------------------------------------------------------------------
 Program ID   : ORAD0129.jsp
 Program name : ADMIN > 배치 > 배치로그조회
 Description  : 
 Programer    : 권성학
 Date created : 2021.05.27
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@page import="com.shbank.orms.comm.SysDateDao"%>
<%@ include file="../comm/comUtil.jsp" %>
<%
	Vector batStscLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");

	SysDateDao dao = new SysDateDao(request);
	String sch_inq_bas_dt = dao.getSysdate();//yyyymmdd
	String txt_inq_bas_dt = sch_inq_bas_dt.substring(0,4)+"-"+sch_inq_bas_dt.substring(4,6)+"-"+sch_inq_bas_dt.substring(6,8);
%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<%@ include file="../comm/library.jsp" %>
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
				
				initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden",MenuFilter:0 }; //좌측에 고정 컬럼의 수
				initData.Cols = [                                                                                                                                                                                            
					{Header:"그룹기관코드",Type:"Text",Width:150,Align:"Center",SaveName:"grp_org_c",MinWidth:60, Hidden:true, Edit:false, Wrap:true},
					{Header:"계열사",Type:"Text",Width:150,Align:"Center",SaveName:"grp_org_nm",MinWidth:60, Hidden:false, Edit:false, Wrap:true},
					{Header:"배치작업ID",Type:"Text",Width:150,Align:"Center",SaveName:"bat_pgid",MinWidth:60, Hidden:false, Edit:false, Wrap:true},
					{Header:"배치작업명",Type:"Text",Width:150,Align:"Left",SaveName:"btwknm",MinWidth:60, Hidden:false, Edit:false, Wrap:true},
					{Header:"시작시각",Type:"Text",Width:150,Align:"Center",SaveName:"btwk_st_dtm",MinWidth:60, Hidden:false, Edit:false, Wrap:true},
					{Header:"종료시각",Type:"Text",Width:150,Align:"Center",SaveName:"btwk_ed_dtm",MinWidth:60, Hidden:false, Edit:false, Wrap:true},
					{Header:"소요시간",Type:"Text",Width:150,Align:"Center",SaveName:"rqrdtime",MinWidth:60, Hidden:false, Edit:false, Wrap:true},
					{Header:"처리구분",Type:"Text",Width:50,Align:"Center",SaveName:"prcsds",MinWidth:60, Hidden:false, Edit:false, Wrap:true},
					{Header:"총건수",Type:"Int",Width:120,Align:"Right",SaveName:"btwk_all_prc_cn",MinWidth:60, Hidden:false, Edit:false, Wrap:true},
					{Header:"미처리건수",Type:"Int",Width:120,Align:"Right",SaveName:"btwk_err_cn",MinWidth:60, Hidden:false, Edit:false, Wrap:true},
					{Header:"처리건수",Type:"Int",Width:120,Align:"Right",SaveName:"btwk_nmlprc_cn",MinWidth:60, Hidden:false, Edit:false, Wrap:true},
					{Header:"상태코드",Type:"Text",Width:150,Align:"Left",SaveName:"btwk_stsc",MinWidth:60, Hidden:true, Edit:false, Wrap:true},
					{Header:"상태",Type:"Text",Width:50,Align:"Center",SaveName:"intg_cnm",MinWidth:60, Hidden:false, Edit:false, Wrap:true},
				];
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
				
				mySheet.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
				
				doAction('search');
				
			}
			
			function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
				
				if(Row >= mySheet.GetDataFirstRow()){
					$("#logtext").val("");
					$("#winLog").show();
					
					$("form[name=popForm] [name=sch_grp_org_c]").val(mySheet.GetCellValue(Row,"grp_org_c"));
					$("form[name=popForm] [name=grp_bat_pgid]").val(mySheet.GetCellValue(Row,"bat_pgid"));
					
					var btwk_st_dtm = mySheet.GetCellValue(Row,"btwk_st_dtm");
					btwk_st_dtm = btwk_st_dtm.replace(/:/gi,"");
					btwk_st_dtm = btwk_st_dtm.replace(/\s/gi,"");
					btwk_st_dtm = btwk_st_dtm.replace(/\//gi,"");
					$("form[name=popForm] [name=prc_dtm]").val(btwk_st_dtm);
						
						
					var f = document.popForm;
					WP.clearParameters();
					WP.setParameter("method", "Main");
					WP.setParameter("commkind", "adm");
					WP.setParameter("process_id", "ORAD012903");
					WP.setForm(f);
					
					var url = "<%=System.getProperty("contextpath")%>/comMain.do";
					var inputData = WP.getParams();
					showLoadingWs(); // 프로그래스바 활성화
					
					WP.load(url, inputData,{
						
						success: function(result){
							if(result!='undefined' && result.rtnCode=="0"){
								var rList = result.DATA;
								var text = "";
								
								for(var i=0;i<rList.length;i++){
									text += rList[i].bat_log_cntn + "\n";
								}
								$("#logtext").val(text);
							}else if(result!='undefined' && result.rtnCode!="0"){
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
				}
				//alert(Row);
			}
			
			function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
				//alert(Row);
			}
			
			
			var row = "";
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			var sch_grp_org_c = "";
						
			/*Sheet 각종 처리*/
			function doAction(sAction) {
				switch(sAction) {
					case "search":  //데이터 조회
						//var opt = { CallBack : DoSearchEnd };
						var opt = {};
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("adm");
						$("form[name=ormsForm] [name=process_id]").val("ORAD012902");
						
						sch_grp_org_c = $("form[name=ormsForm] [name=sch_grp_org_c]").val();
					
						mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
				
						break;
					case "down2excel":
						var params = {ExcelHeaderRowHeight:25, ExcelRowHeight:17, ExcelFontSize:10, FileName : "배치로그.xlsx",  SheetName : "Sheet1"} ;
						
						mySheet.Down2Excel(params);
	
						break;
				}
			}
	
			
			function mySheet_OnSearchEnd(code, message) {
	
				if(code != 0) {
					alert("조회 중에 오류가 발생하였습니다..");
				}else{
				}
			}
			
			function EnterkeySubmit(){
				if(event.keyCode == 13){
					doAction("search");
					return true;
				}else{
					return true;
				}
			}

	</script>
		
	</head>
	<body>
		<div class="container">
			<%@ include file="../comm/header.jsp" %>
			<!-- content -->
			<div class="content">
				<form name="ormsForm">
				<input type="hidden" id="path" name="path" />
				<input type="hidden" id="process_id" name="process_id" />
				<input type="hidden" id="commkind" name="commkind" />
				<input type="hidden" id="method" name="method" />
	
				<div class="box box-search">
					<div class="box-body">
						<div class="wrap-search">
							<table>
								<tbody>
									<tr>
										<th>계열사</th>
										<td>
											<div class="input-group w150">
												<select name="sch_grp_org_c" id="sch_grp_org_c" class="form-control">
													<option value="">전체</option>
	<%
			for(int i=0;i<vAllGrpList.size();i++){
				HashMap hMap = (HashMap)vAllGrpList.get(i);
	%>
													<option value="<%=(String)hMap.get("grp_org_c")%>"><%=(String)hMap.get("grp_orgnm")%></option>
	<%
			}
	%>
												</select>										
											</div>
										</td>
										<th>실행주기</th>
										<td>
											<div class="select w150">
												<select name="sch_btwk_exe_fq_dsc" id="sch_btwk_exe_fq_dsc" class="form-control">
													<option value="">전체</option>
													<option value="1">일</option>
													<option value="2">월</option>
													<option value="3">분기</option>
												</select>
											</div>
										</td>
										<th>기간</th>
										<td>
											<div class="form-inline">
												<div class="input-group">
													<input type="text" id="sch_st_dt" name="sch_st_dt" class="form-control w100" value="<%=txt_inq_bas_dt %>">
													<span class="input-group-btn">
														<button type="button" class="btn btn-default ico" onclick="showCalendar('yyyy-MM-dd','sch_st_dt');"><i class="fa fa-calendar"></i></button>
													</span>
												</div>
												<div class="input-group">
													<div class="input-group-addon"> ~ </div>
													<input type="text" id="sch_ed_dt" name="sch_ed_dt" class="form-control w100" value="<%=txt_inq_bas_dt %>">
													<span class="input-group-btn">
														<button type="button" class="btn btn-default ico" onclick="showCalendar('yyyy-MM-dd','sch_ed_dt');"><i class="fa fa-calendar"></i></button>
													</span>
												</div>
											</div>
										</td>
									</tr>
									<tr>
										<th>배치작업ID</th>
										<td>
											<input type="text" name="sch_btwk_id" id="sch_btwk_id" class="form-control w150" onkeypress="EnterkeySubmit();" maxlength="20">
										</td>
										<th>배치작업명</th>
										<td>
											<input type="text" name="sch_btwknm" id="sch_btwknm" class="form-control w150" onkeypress="EnterkeySubmit();" maxlength="100">
										</td>
										<th>상태</th>
										<td>
											<div class="select w150">
												<select name="sch_btwk_stsc" id="sch_btwk_stsc" class="form-control">
													<option value="">전체</option>
		<%
				for(int i=0;i<batStscLst.size();i++){
					HashMap hMap = (HashMap)batStscLst.get(i);
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
						<button type="button" class="btn btn-primary search" onclick="javascript:doAction('search');">조회</button>
					</div>
				</div>
	
	
				<div class="box box-grid">
					<div class="box-header">
						<div class="area-tool">
							<button type="button" class="btn btn-xs btn-default" type="button" onclick="javascript:doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
						</div>
					</div>
					<div class="box-body">
						<div class="wrap-grid h550">
							<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%"); </script>
						</div>
					</div>
				</div>
				</form>
			</div>
			<!-- content //-->
			
		</div>	

		<!-- 팝업 -->
		<div id="winLog" class="popup modal" style="background-color: transparent">
			<div class="p_frame w1000 h800">
				<form name="popForm" method="post">
				<input type="hidden" id="path" name="path" />
				<input type="hidden" id="process_id" name="process_id" />
				<input type="hidden" id="commkind" name="commkind" />
				<input type="hidden" id="method" name="method" />
				<input type="hidden" id="sch_grp_org_c" name="sch_grp_org_c" />
				<input type="hidden" id="grp_bat_pgid" name="grp_bat_pgid" />
				<input type="hidden" id="prc_dtm" name="prc_dtm" />
				<div class="p_head">
					<h3 class="title md">배치작업 로그</h3>
				</div>
				<div class="p_body">
					<div class="p_wrap">
						<textarea id="logtext" class="form-control textarea" style="height:500px;" readonly></textarea>
					</div><!-- .p_wrap //-->	
				</div><!-- .p_body //-->
				<div class="p_foot">
					<div class="btn-wrap center">
						<button type="button" class="btn btn-default btn-close">닫기</button>
					</div>
				</div>
				<button type="button" class="ico close fix btn-close">
					<span class="blind">닫기</span>
				</button>
			</div>
			<div class="dim p_close"></div>
		</div>
		<!-- popup //-->

	</body>
	<script>
		$(document).ready(function(){
			//열기
			$(".btn-open").click( function(){
				$(".popup").show();
			});
			//닫기
			$(".btn-close").click( function(event){
				$(".popup").hide();
				event.preventDefault();
			});
			// dim (반투명 ) 영역 클릭시 팝업 닫기 
			$('.popup >.dim').click(function () {  
				$(".popup").hide();
				//$(".popup").hide();
			});
			$(".btn-pclose").click( function(){
				$(".popup").hide();
			});
		});
	</script>
</html>