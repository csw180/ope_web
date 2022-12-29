<%--
/*---------------------------------------------------------------------------
 Program ID   : ORLS0105.jsp
 Program name : 계정목록 (팝업)
 Description  : LDM-04
 Programer    : 이규탁
 Date created : 2022.08.10
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
//CommUtil.getCommonCode() -> 공통코드조회 메소드
Vector vLssAcgAcccLst = CommUtil.getCommonCode(request, "LSS_ACG_ACCC");
if(vLssAcgAcccLst==null) vLssAcgAcccLst = new Vector();


%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<%@ include file="../comm/library.jsp" %>
		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<script>
		$(document).ready(function(){
			
			$("#winAccConn",parent.document).show();
			// ibsheet 초기화
			initIBSheet();
			$("#brc").val(parent.ormsForm.ocu_brc.value);
			$("#brnm").val(parent.ormsForm.ocu_brnm.value);
			set_by_role(parent.parent.ormsForm.role_id.value);
			doAction('search');
			});
			
			/*Sheet 기본 설정 */
			function initIBSheet() {
				//시트 초기화
				mySheet.Reset();
				
				var initData = {};
				
				initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly }; //좌측에 고정 컬럼의 수
				initData.Cols = [
				    {Header:"그룹기관코드",		Type:"Text",	SaveName:"grp_org_c",	Edit:false,		Hidden:true},
				    {Header:"계정구분코드",		Type:"Text",	SaveName:"acc_dsc",		Edit:false,		Hidden:true},
				    {Header:"계정일련번호",		Type:"Text",	SaveName:"acc_sqno",	Edit:false,		Hidden:true},
				    {Header:"No",			Type:"Seq",		SaveName:"rw_no",		Edit:false,		Hidden:true},
				    {Header:"회계처리일자",		Type:"Date",	SaveName:"acg_prc_dt",	Edit:false,									MinWidth:90,Align:"Center",Format:"yyyyMMdd"},
				    {Header:"부서코드",		Type:"Text",	SaveName:"acc_brc",		Edit:false,		Hidden:true},
				    {Header:"부서/영업점",		Type:"Text",	SaveName:"brnm",		Edit:false,									MinWidth:80,Align:"Center"},
				    {Header:"계정과목명",		Type:"Text",	SaveName:"acc_sbjnm",	Edit:false,									MinWidth:130,Align:"Left"},
				    {Header:"손실회계계정코드",	Type:"Text",	SaveName:"lss_acg_accc",Edit:false,									WidtMinh:150,Align:"Left"},
				    {Header:"차대",			Type:"Combo",	SaveName:"rvpy_dsc", 	Edit:false,									MinWidth:40,Align:"Center", 											ComboText:"입금|지급", ComboCode:"1|2"},
				    {Header:"금액",			Type:"Int",		SaveName:"acc_am",			Edit:false,									MinWidth:90,Align:"Right"},
				    {Header:"거래내역",		Type:"Text",	SaveName:"tr_cntn",		Edit:false,									MinWidth:180,Align:"Center"},
				    {Header:"정정취소구분",		Type:"Combo",	SaveName:"crc_can_dsc", Edit:false,									MinWidth:80,Align:"Center", 											ComboText:"정상|정정|취소|원인거래정정|원인거래취소", ComboCode:"0|1|2|3|4"},
				    {Header:"손실등록",		Type:"Combo", 	SaveName:"lss_rg_stsc", Edit:false,									MinWidth:80, Align:"Center",											ComboText:"N|Y|불필요", ComboCode:"|01|02"},
				    {Header:"손실등록요청일자",	Type:"Text",	SaveName:"lss_rg_rqr_dt",Edit:false,	Hidden:true},
				    {Header:"제외사유내용",		Type:"Text",	SaveName:"x_rsnctt",	Edit:false,		Hidden:true}
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
				
				//헤더기능 해제
				mySheet.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
				//마우스 우측 버튼 메뉴 설정
				//setRMouseMenu(mySheet);
				
				//doAction('search');
				
			}
			
			function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
				//alert(Row);
				if(Row >= mySheet.GetDataFirstRow()){
					$("#grp_org_c").val(mySheet.GetCellValue(Row,"grp_org_c"));
					$("#acc_dsc").val(mySheet.GetCellValue(Row,"acc_dsc"));
					$("#acc_sqno").val(mySheet.GetCellValue(Row,"acc_sqno"));
					$("#lss_acg_accc").val(mySheet.GetCellValue(Row,"lss_acg_accc"));
					$("#acc_brc").val(mySheet.GetCellValue(Row,"acc_brc"));
					$("#crc_can_dsc").val(mySheet.GetCellValue(Row,"crc_can_dsc"));
					$("#acg_prc_dt").val(mySheet.GetCellValue(Row,"acg_prc_dt"));
					$("#acc_am").val(mySheet.GetCellValue(Row,"acc_am"));
					$("#tr_cntn").val(mySheet.GetCellValue(Row,"tr_cntn"));
					$("#rvpy_dsc").val(mySheet.GetCellValue(Row,"rvpy_dsc"));
					accConnSave(Row);
				}
			}
			
			function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
				//alert(Row);
				if(Row >= mySheet.GetDataFirstRow()){
					$("#grp_org_c").val(mySheet.GetCellValue(Row,"grp_org_c"));
					$("#acc_dsc").val(mySheet.GetCellValue(Row,"acc_dsc"));
					$("#acc_sqno").val(mySheet.GetCellValue(Row,"acc_sqno"));
					$("#lss_acg_accc").val(mySheet.GetCellValue(Row,"lss_acg_accc"));
					$("#acc_brc").val(mySheet.GetCellValue(Row,"acc_brc"));
					$("#crc_can_dsc").val(mySheet.GetCellValue(Row,"crc_can_dsc"));
					$("#acg_prc_dt").val(mySheet.GetCellValue(Row,"acg_prc_dt"));
					$("#acc_am").val(mySheet.GetCellValue(Row,"acc_am"));
					$("#tr_cntn").val(mySheet.GetCellValue(Row,"tr_cntn"));
					$("#rvpy_dsc").val(mySheet.GetCellValue(Row,"rvpy_dsc"));
				}
			}
			
	
			
			var row = "";
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
						
			/*Sheet 각종 처리*/
			function doAction(sAction) {
				switch(sAction) {
					case "search":  //데이터 조회
						//var opt = { CallBack : DoSearchEnd };
						var opt = {};
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("los");
						$("form[name=ormsForm] [name=process_id]").val("ORLS010502");
						$("form[name=ormsForm] [name=grp_org_c]").val("<%=grp_org_c%>");
						$("form[name=ormsForm] [name=acc_dsc]").val(parent.accConnForm.sheetno.value);
						ormsForm.st_dt.value = ormsForm.txt_st_dt.value.replace(/-/gi,"");
						ormsForm.ed_dt.value = ormsForm.txt_ed_dt.value.replace(/-/gi,"");
						if(parent.accConnForm.sheetno.value=="3"||parent.accConnForm.sheetno.value=="4"){	//보험은 입금만 조회
							ormsForm.rvpy_dsc.value = ""
						}else if(parent.accConnForm.sheetno.value=="1"){  //손실 발생금액
							ormsForm.rvpy_dsc.value = "2";
						}else if(parent.accConnForm.sheetno.value=="2"){  //보험은 입금만 조회
							ormsForm.rvpy_dsc.value = "1";
						}
						if(ormsForm.txt_st_am.value==""){
							ormsForm.st_am.value = "";
						}else{
							ormsForm.st_am.value = ormsForm.txt_st_am.value * 10000;	
						}
						if(ormsForm.txt_ed_am.value==""){
							ormsForm.ed_am.value = "";
						}else{
							ormsForm.ed_am.value = ormsForm.txt_ed_am.value * 10000;	
						}
						mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
						break;
				}
			}

			
			function mySheet_OnSearchEnd(code, message) {
	
				if(code != 0) {
					alert("조회 중에 오류가 발생하였습니다..");
				}else{
				}
			}

			// 연결계정 연결
			function accConnSave(Row){
				if(Row==-1){
					alert("계정을 선택하세요.");
				}else{
					if(checkAcc(Row)){
						parent.addAccConn(
								mySheet.GetCellValue(Row,"acc_sqno"),
								mySheet.GetCellValue(Row,"lss_acg_accc"),
								mySheet.GetCellValue(Row,"crc_can_dsc"),
								mySheet.GetCellValue(Row,"acg_prc_dt"),
								mySheet.GetCellValue(Row,"acc_am"),
								mySheet.GetCellValue(Row,"tr_cntn"),
								mySheet.GetCellValue(Row,"rvpy_dsc"),
								mySheet.GetCellValue(Row,"acc_brc"),
								""
								);
						parent.accConnClose();
					}
				}
			}			
			
			function checkAcc(Row){
				for(var nCnt=parent.mySheet1.GetDataFirstRow(); nCnt <= parent.mySheet1.GetDataLastRow(); nCnt++){
					if( parent.mySheet1.GetCellValue(nCnt,"lss_acg_accc") == mySheet.GetCellValue(Row,"lss_acg_accc") &&
						parent.mySheet1.GetCellValue(nCnt,"acc_brc") == mySheet.GetCellValue(Row,"acc_brc") &&
						parent.mySheet1.GetCellValue(nCnt,"acc_sqno") == mySheet.GetCellValue(Row,"acc_sqno") &&
						parent.mySheet1.GetCellValue(nCnt,"rvpy_dsc") == mySheet.GetCellValue(Row,"rvpy_dsc") &&
						parent.mySheet1.GetCellValue(nCnt,"crc_can_dsc") == mySheet.GetCellValue(Row,"crc_can_dsc") &&
						parent.mySheet1.GetCellValue(nCnt,"acg_prc_dt") == mySheet.GetCellValue(Row,"acg_prc_dt")){
						alert("손실발생금액에 해당계정이 등록중입니다.");
						return false;
					}
				}	
				for(var nCnt=parent.mySheet2.GetDataFirstRow(); nCnt <= parent.mySheet2.GetDataLastRow(); nCnt++){
					if( parent.mySheet2.GetCellValue(nCnt,"lss_acg_accc") == mySheet.GetCellValue(Row,"lss_acg_accc") &&
						parent.mySheet2.GetCellValue(nCnt,"acc_brc") == mySheet.GetCellValue(Row,"acc_brc") &&
						parent.mySheet2.GetCellValue(nCnt,"acc_sqno") == mySheet.GetCellValue(Row,"acc_sqno") &&
						parent.mySheet2.GetCellValue(nCnt,"rvpy_dsc") == mySheet.GetCellValue(Row,"rvpy_dsc") &&
						parent.mySheet2.GetCellValue(nCnt,"crc_can_dsc") == mySheet.GetCellValue(Row,"crc_can_dsc") &&
						parent.mySheet2.GetCellValue(nCnt,"acg_prc_dt") == mySheet.GetCellValue(Row,"acg_prc_dt")){
						alert("보험회수금액에 해당계정이 등록중입니다.");
						return false;
					}
				}
				for(var nCnt=parent.mySheet3.GetDataFirstRow(); nCnt <= parent.mySheet3.GetDataLastRow(); nCnt++){
					if( parent.mySheet3.GetCellValue(nCnt,"lss_acg_accc") == mySheet.GetCellValue(Row,"lss_acg_accc") &&
						parent.mySheet3.GetCellValue(nCnt,"acc_brc") == mySheet.GetCellValue(Row,"acc_brc") &&
						parent.mySheet3.GetCellValue(nCnt,"acc_sqno") == mySheet.GetCellValue(Row,"acc_sqno") &&
						parent.mySheet3.GetCellValue(nCnt,"rvpy_dsc") == mySheet.GetCellValue(Row,"rvpy_dsc") &&
						parent.mySheet3.GetCellValue(nCnt,"crc_can_dsc") == mySheet.GetCellValue(Row,"crc_can_dsc") &&
						parent.mySheet3.GetCellValue(nCnt,"acg_prc_dt") == mySheet.GetCellValue(Row,"acg_prc_dt")){
						alert("소송금액에 해당계정이 등록중입니다.");
						return false;
					}
				}
				for(var nCnt=parent.mySheet4.GetDataFirstRow(); nCnt <= parent.mySheet4.GetDataLastRow(); nCnt++){
					if( parent.mySheet4.GetCellValue(nCnt,"lss_acg_accc") == mySheet.GetCellValue(Row,"lss_acg_accc") &&
						parent.mySheet4.GetCellValue(nCnt,"acc_brc") == mySheet.GetCellValue(Row,"acc_brc") &&
						parent.mySheet4.GetCellValue(nCnt,"acc_sqno") == mySheet.GetCellValue(Row,"acc_sqno") &&
						parent.mySheet4.GetCellValue(nCnt,"rvpy_dsc") == mySheet.GetCellValue(Row,"rvpy_dsc") &&
						parent.mySheet4.GetCellValue(nCnt,"crc_can_dsc") == mySheet.GetCellValue(Row,"crc_can_dsc") &&
						parent.mySheet4.GetCellValue(nCnt,"acg_prc_dt") == mySheet.GetCellValue(Row,"acg_prc_dt")){
						alert("기타금액에 해당계정이 등록중입니다.");
						return false;
					}
				}
				return true;
			}
			function set_by_role(role){
				if(role=='orm'){
					document.getElementById('brnm_btn').style.display = "table-row";
					document.getElementById('brnm').disabled = false;
				}else if(role=='ormld'){
					document.getElementById('brnm_btn').style.display = "table-row";
					document.getElementById('brnm').disabled = false;
				}else if(role=='nml'){
					document.getElementById('brnm_btn').style.display = "none";
					document.getElementById('brnm').disabled = true;
				}else if(role=='admn'){
					document.getElementById('brnm_btn').style.display = "table-row";
					document.getElementById('brnm').disabled = false;
				}
			}

			
			
	</script>
		
	</head>

	<body style="background-color:transparent">
<!--	<p><button class="btn-open"><span> 팝업 열기</span></button></p>-->
		<!-- 팝업 -->
		<div id="" class="popup modal block aa">
				<div class="p_frame w1000">
					<div class="p_head">
						<h3 class="title md">계정목록</h3>
					</div>
					<div class="p_body">
						<div class="p_wrap">
							<form name="ormsForm">
								<input type="hidden" id="path" name="path" />
								<input type="hidden" id="process_id" name="process_id" />
								<input type="hidden" id="commkind" name="commkind" />
								<input type="hidden" id="method" name="method" />
								<input type="hidden" id="grp_org_c" name="grp_org_c" />
								<input type="hidden" id="acc_dsc" name="acc_dsc" />
								<input type="hidden" id="acc_sqno" name="acc_sqno" />
								<input type="hidden" id="lss_acg_accc" name="lss_acg_accc" />
								<input type="hidden" id="acc_brc" name="acc_brc" />
								<input type="hidden" id="crc_can_dsc" name="crc_can_dsc" />
								<input type="hidden" id="acg_prc_dt" name="acg_prc_dt" />
								<input type="hidden" id="acc_am" name="acc_am" />
								<input type="hidden" id="tr_cntn" name="tr_cntn" />
								<input type="hidden" id="rvpy_dsc" name="rvpy_dsc" />

								<!-- 조회 -->
								<div class="box box-search">
									<div class="box-body">
										<div class="wrap-search">
										<table>
											<tbody>
												<tr>
													<th scope="row">부서/영업점</th>
													<td>
														<div class="input-group">
														  <input type="text" class="form-control" id="brnm" name="brnm" onKeyPress="EnterkeySubmitOrg('brnm','orgSearchEnd');" value="">
														  <input type="hidden" id="brc" name="brc" value="" />
														  <span class="input-group-btn">
															<button class="btn btn-default ico search" type="button" id="brnm_btn" onclick="schOrgPopup('brnm', 'orgSearchEnd');" style="display:none"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
														  </span>
														</div><!-- /input-group -->
													</td>
													<th scope="row">계정과목명</th>
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
													<th scope="row">기간</th>
													<td>														
															<span class="w140 fl">
																	<input type="hidden" id="st_dt" name="st_dt">
																	<input type="text" id="txt_st_dt" name="txt_st_dt" class="form-control w70p fl" disabled/>
																		<button type="button" class="btn btn-default ico fl" onclick="showCalendar('yyyy-MM-dd','txt_st_dt');">
																		<i class="fa fa-calendar"></i>
																	</button>
															</span>
															<span class="mr10 mt5 fl"> ~ </span> 
															<span class="w140 fl">
																<input type="hidden" id="ed_dt" name="ed_dt">
																<input type="text" id="txt_ed_dt" name="txt_ed_dt" class="form-control w70p fl" disabled/>
																	<button type="button" class="btn btn-default ico fl" onclick="showCalendar('yyyy-MM-dd','txt_ed_dt');">
																	<i class="fa fa-calendar"></i>
																</button>
															</span>
													</td>
												</tr>
												<tr>
													<th scope="row">정렬기준</th>
													<td>
														<span class="select">
															<select class="form-control w150" id="sort" name="sort" >
															<option value="ASC">오름차순</option>
															<option value="DESC">내림차순</option>
															</select>
														</span>
													</td>											
													<th scope="row">금액</th>
													<td colspan="3" class="form-inline">
														<div class="form-group">
															<div class="input-group">
																<input type="hidden" id="st_am" name="st_am"/> 
																<input type="text"  class="form-control text-right"  style="width:80px;" id="txt_st_am" name="txt_st_am"/> 
																<span class="input-group-addon">만원 </span>
															</div>
														</div>
														<span class="input-group-addon ib mr5"> ~ </span>
														<div class="input-group">
															<input type="hidden" id="ed_am" name="ed_am" />
															<input type="text" class="form-control text-right" style="width:80px;" id="txt_ed_am" name="txt_ed_am" />
															<span class="input-group-addon">만원 </span>
														</div>
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
							<div class="box box-grid">
								<!-- /.box-header -->
								<div class="box-body">
									<div class="wrap-grid scroll h280">
										<script> createIBSheet("mySheet", "100%", "100%"); </script>
									</div><!-- .wrap //-->
								</div><!-- .box-body //-->
								
							</div><!-- .box //-->
						</div><!-- .p_wrap //-->	
					</div><!-- .p_body //-->
					<div class="p_foot">
						<div class="btn-wrap center">
							<button type="button" class="btn btn-primary" onclick="javascript:accConnSave(mySheet.GetSelectRow());">연결</button>
							<button type="button" class="btn btn-default btn-close">닫기</button>
						</div>
					</div><!-- .p_foot //-->
				</div>
				
					<!-- popup -->
				<%@ include file="../comm/OrgInfP.jsp" %> <!-- 부서 공통 팝업 -->
				
				<script>
					// 부서검색 완료
					function orgSearchEnd(brc, brnm){
						$("#brc").val(brc);
						$("#brnm").val(brnm);
						$("#winBuseo").hide();
					}

					
					function mySheet_OnSaveEnd(code, msg) {
						
					    if(code >= 0) {
					        alert(msg);  // 저장 성공 메시지
							parent.addAccConn(
									$("#acc_sqno").val,
									$("#lss_acg_accc").val,
									$("#crc_can_dsc").val,
									$("#am").val,
									$("#tr_cntn").val,
									$("#rvpy_dsc").val,
									$("#acc_brc").val,
									""
									);
							parent.accConnClose();
					    } else {
					        alert(msg); // 저장 실패 메시지
					    }
					}
					
					$(document).ready(function(){
						
						//열기
						$(".btn-open").click( function(){
							$(".popup").show();
						});
						//닫기
						$(".btn-close").click( function(event){
							parent.accConnClose();
							event.preventDefault();
						});
					});
					
					

					
						
				</script>
				
			<div class="dim p_close"></div>
		</div>
		<!-- popup //-->
	</body>

</html>